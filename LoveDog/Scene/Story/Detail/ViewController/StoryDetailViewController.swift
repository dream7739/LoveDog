//
//  StoryDetailViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import UIKit
import WebKit
import SnapKit
import Toast
import RxSwift
import RxCocoa
import RxDataSources
import iamport_ios

final class StoryDetailViewController: BaseViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let commentView = CommentView()
    private let wkWebView = WKWebView()

    private let followButtonClicked = PublishRelay<Void>()
    private let likeButtonClicked = PublishRelay<Bool>()
    private let cheerButtonClicked = PublishRelay<Void>()
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
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            case .like:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
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
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(commentView)
        view.addSubview(wkWebView)
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
        
        wkWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
        
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: StoryDetailViewController.commentSectionHeader, withReuseIdentifier: TitleHeaderView.identifier)
        
        collectionView.register(
            DetailCommentCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailCommentCollectionViewCell.identifier
        )
        
        wkWebView.backgroundColor = .clear
        wkWebView.isHidden = true
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
        let input = StoryDetailViewModel.Input(
            callRequest: BehaviorRelay(value: ()),
            followButtonClicked: followButtonClicked,
            likeButtonClicked: likeButtonClicked, 
            cheerButtonClicked: cheerButtonClicked,
            cheerPaymentCompleted: PublishRelay<ValidationRequest>(),
            commentText: commentView.inputTextView.rx.text.orEmpty,
            uploadComment: commentView.sendButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        let dataSource = configureDataSource()
        
        output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.payment
            .bind(with: self) { owner, payment in
                print(payment)
                owner.wkWebView.isHidden = false

                Iamport.shared.paymentWebView(webViewMode: owner.wkWebView, userCode: APIKey.paymentUserCode, payment: payment) { response in
                    guard let response, let impId = response.imp_uid else { return }
                    let validationRequest = ValidationRequest(impUid: impId, postId: owner.viewModel.postId)
                    print("VALIDATION REQUEST", validationRequest)
                    input.cheerPaymentCompleted.accept(validationRequest)
                    
                }
            }
            .disposed(by: disposeBag)
        
        output.validationResult
            .bind(with: self) { owner, value in
                owner.wkWebView.isHidden = true
                owner.view.makeToast(value)
            }
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
    
    private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<DetailSectionModel> {
        return RxCollectionViewSectionedReloadDataSource(configureCell:  { dataSource, collectionView, indexPath, _ in
            switch dataSource[indexPath] {
            case .profile(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailProfileCollectionViewCell.identifier, for: indexPath) as?  DetailProfileCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data)
                cell.profileView.followButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.followButtonClicked.accept(())
                    }
                    .disposed(by: cell.disposeBag)
                return cell
            case .image(let image):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCollectionViewCell.identifier, for: indexPath) as? DetailImageCollectionViewCell else { return UICollectionViewCell() }
                cell.configureImage(image)
                return cell
            case .like(let isLiked, let likeCount, let commentCount, let cheerCount):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLikeCollectionViewCell.identifier, for: indexPath) as? DetailLikeCollectionViewCell else { return UICollectionViewCell() }

                cell.configureData(isLiked, likeCount, commentCount, cheerCount)
                
                cell.likeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        cell.isClicked = false
                        owner.likeButtonClicked.accept(cell.isLiked)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.cheerButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.cheerButtonClicked.accept(())
                    }
                    .disposed(by: cell.disposeBag)
                
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
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: StoryDetailViewController.commentSectionHeader, withReuseIdentifier: TitleHeaderView.identifier, for: indexPath) as? TitleHeaderView {
                header.configureTitle("댓글")
                return header
            }
            
            return UICollectionReusableView()
        }
    }
    
}

enum DetailSectionModel: SectionModelType {
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
    init(original: DetailSectionModel, items: [SectionItem]) {
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
    case like(isLiked: Bool, likeCount: String, commentCount: String, cheerCount: String)
    case content(title: String, content: String)
    case comment(comments: Comment)
}
