//
//  StoryDetailViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class StoryDetailViewController: BaseViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let commentView = CommentView()
    private let viewModel: StoryDetailViewModel
    private let disposeBag = DisposeBag()
    
    static let commentSectionHeader = "commentSectionHeader"
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, env in
            switch Section.allCases[section] {
            case .profile:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .image:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            case .like:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(35))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .content:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            case .comment:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: StoryDetailViewController.commentSectionHeader, alignment: .top)
                
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            }
        }
        
        return layout
    }
    
    init(viewModel: StoryDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constant.Navigation.story
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(commentView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(commentView.snp.top)
        }
        
        commentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.height.greaterThanOrEqualTo(45)
        }
    }
    
    override func configureView() {
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(
            DetailProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailProfileCollectionViewCell.identifier
        )
        collectionView.register(
            DetailImageCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailImageCollectionViewCell.identifier
        )
        collectionView.register(
            DetailLikeCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailLikeCollectionViewCell.identifier
        )
        collectionView.register(
            DetailContentCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailContentCollectionViewCell.identifier
        )
        
        collectionView.register(CommentTitleView.self, forSupplementaryViewOfKind: StoryDetailViewController.commentSectionHeader, withReuseIdentifier: CommentTitleView.identifier)
        
        collectionView.register(
            DetailCommentCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailCommentCollectionViewCell.identifier
        )
    }
}

extension StoryDetailViewController {
    private enum Section: CaseIterable {
        case profile
        case image
        case like
        case content
        case comment
    }
    
    private func bind() {
        let input = StoryDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        let dataSource = configureDataSource()
        
        output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        commentView.inputTextView
            .rx.didChange
            .bind(with: self) { owner, _ in
                let size = CGSize(width: owner.commentView.inputTextView.frame.width, height: owner.commentView.frame.height)
                let estimatedSize = owner.commentView.inputTextView.sizeThatFits(size)
                let isMaxHeight = estimatedSize.height > 88
                if isMaxHeight {
                    owner.commentView.inputTextView.isScrollEnabled = true
                } else {
                    owner.commentView.inputTextView.isScrollEnabled = false
                    
                    owner.commentView.inputTextView.snp.updateConstraints { make in
                        make.height.equalTo(estimatedSize.height)
                    }

                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<MultipleSectionModel> {
        return RxCollectionViewSectionedReloadDataSource(configureCell:  { dataSource, collectionView, indexPath, _ in
            switch dataSource[indexPath] {
            case .profile(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailProfileCollectionViewCell.identifier, for: indexPath) as?  DetailProfileCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data)
                return cell
            case .image(let image):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCollectionViewCell.identifier, for: indexPath) as? DetailImageCollectionViewCell else { return UICollectionViewCell() }
                cell.configureImage(image)
                return cell
            case .like(let likeCount, let commentCount):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLikeCollectionViewCell.identifier, for: indexPath) as? DetailLikeCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(likeCount, commentCount)
                return cell
            case .content(let title, let content):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailContentCollectionViewCell.identifier, for: indexPath) as? DetailContentCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(title, content)
                return cell
            case .comment(let comments):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCommentCollectionViewCell.identifier, for: indexPath) as? DetailCommentCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(comments)
                return cell
            }
        }) { dataSource, collectionView, kind, indexPath in
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: StoryDetailViewController.commentSectionHeader, withReuseIdentifier: CommentTitleView.identifier, for: indexPath) as? CommentTitleView {
                header.configureTitle("댓글")
                return header
            }
            
            return UICollectionReusableView()
        }
    }
    
}

enum MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    //섹션
    case profile(items: [SectionItem])
    case image(items: [SectionItem])
    case like(items: [SectionItem])
    case content(items: [SectionItem])
    case comment(items: [SectionItem])
    
    //섹션별 아이템
    var items: [SectionItem] {
        switch self {
        case .profile(let items):
            return items.map { $0 }
        case .image(let items):
            return items.map { $0 }
        case .like(items: let items):
            return items.map { $0}
        case .content(let items):
            return items.map { $0 }
        case .comment(let items):
            return items.map { $0 }
        }
    }
    
    //섹션 생성자
    init(original: MultipleSectionModel, items: [SectionItem]) {
        switch original {
        case .profile(let items):
            self = .profile(items: items)
        case .image(let items):
            self = .image(items: items)
        case .like(let items):
            self = .like(items: items)
        case .content(let items):
            self = .content(items: items)
        case .comment(let items):
            self = .comment(items: items)
        }
    }
    
}

enum SectionItem {
    //섹션에 들어갈 아이템 단건
    case profile(data: Creator)
    case image(image: String)
    case like(likeCount: String, commentCount: String)
    case content(title: String, content: String)
    case comment(comments: Comment)
}
