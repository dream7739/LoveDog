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

final class StoryViewController: BaseViewController {
    private let writeButton = FloatingButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
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
        collectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
    }
    
    private func bind() {
        let input = StoryViewModel.Input(
            request: BehaviorRelay(value: FetchPostRequest(next: "")),
            prefetch: PublishRelay<Void>()
        )
        
        let output = viewModel.transform(input: input)
        
        output.postList
            .bind(to: collectionView.rx.items(cellIdentifier: StoryCollectionViewCell.identifier, cellType: StoryCollectionViewCell.self)){ row, element, cell in
                cell.configureData(element)
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems
            .bind(with: self) { owner, value in
                value.forEach  { idx in
                    if idx.item == owner.viewModel.postResponse.data.count - 4 {
                        input.prefetch.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(Post.self))
            .bind(with: self) { owner, value in
                let viewModel = StoryDetailViewModel()
                viewModel.postId = value.1.post_id
                let detailVC = StoryDetailViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(detailVC, animated: true)
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
    
}
