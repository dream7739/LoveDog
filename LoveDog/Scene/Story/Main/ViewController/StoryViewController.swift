//
//  StoryViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class StoryViewController: BaseViewController {
    private let writeButton = FloatingButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private enum Section: CaseIterable {
        case follower
        case story
    }
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, env in
            switch Section.allCases[section] {
            case .follower:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(800), heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
                return section
            case .story:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(460))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
        
        return layout
    }
    
    private var selectedIndexPath: IndexPath?
    private let viewModel: StoryViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: StoryViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureHierarchy() {
        [collectionView, writeButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        writeButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        navigationItem.title = Constant.Navigation.story
        collectionView.register(FollowCollectionViewCell.self, forCellWithReuseIdentifier: FollowCollectionViewCell.identifier)
        collectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
    }
    
    private func bind() {
        let input = StoryViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            selectFollower: PublishRelay<FollowInfo>(), 
            unselectFollower: PublishRelay<Void>(),
            callProfile: PublishRelay<Void>(),
            callPost: PublishRelay<Void>(),
            callUserPost: PublishRelay<String>(),
            prefetch: PublishRelay<Void>()
        )
        
        let output = viewModel.transform(input: input)
        
        let dataSource = configureDataSource()
        
        output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems
            .bind(with: self) { owner, value in
                value.forEach  { idx in
                    //섹션이 팔로워 섹션이면, 프리패치 하지 않음
                    if idx.section == 0 { return }
                    
                    if idx.item == owner.viewModel.postResponse.data.count - 4 {
                        input.prefetch.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(StorySectionItem.self))
            .bind(with: self) { owner, value in
                switch value.1 {
                case .follower(let item):
                    guard let cell = owner.collectionView.cellForItem(at: value.0) as? FollowCollectionViewCell else { return }
                    cell.isClicked.toggle()
                    
                    if cell.isClicked {
                        owner.selectedIndexPath = value.0
                        input.selectFollower.accept(item)
                    } else {
                        owner.selectedIndexPath = nil
                        input.unselectFollower.accept(())
                    }
                case .story(data: let data):
                    let viewModel = StoryDetailViewModel()
                    viewModel.postId = data.post_id
                    let detailVC = StoryDetailViewController(viewModel: viewModel)
                    owner.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .bind(with: self){ owner, value in
                let viewModel = MakeStoryViewModel()
                let makeVC = UINavigationController(rootViewController: MakeStoryViewController(viewModel: viewModel))
                makeVC.modalPresentationStyle = .fullScreen
                owner.present(makeVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<StorySectionModel> {
        return RxCollectionViewSectionedReloadDataSource(configureCell:  {  [weak self] dataSource, collectionView, indexPath, _ in
            switch dataSource[indexPath] {
            case .follower(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowCollectionViewCell.identifier, for: indexPath) as?  FollowCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data)
                if self?.selectedIndexPath == indexPath {
                    cell.isClicked = true
                } else {
                    cell.isClicked = false
                }
                return cell
            case .story(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as? StoryCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data)
                return cell
            }
        })
    }
    
}

enum StorySectionModel: SectionModelType {
    typealias Item = StorySectionItem
    
    case follower(items: [StorySectionItem])
    case story(items: [StorySectionItem])
    
    //섹션별 아이템
    var items: [StorySectionItem] {
        switch self {
        case .follower(let items):
            return items.map { $0 }
        case .story(let items):
            return items.map { $0 }
        }
    }
    
    //섹션 생성자
    init(original: StorySectionModel, items: [StorySectionItem]) {
        switch original {
        case .follower(let items):
            self = .follower(items: items)
        case .story(let items):
            self = .story(items: items)
        }
    }
}

enum StorySectionItem {
    //섹션에 들어갈 아이템 단건
    case follower(data: FollowInfo)
    case story(data: Post)
    
}
