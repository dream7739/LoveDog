//
//  ProfileViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileViewController: BaseViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ProfileViewController.profileSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    static let profileSectionHeader = "profileSectionHeader"
    
    private let userPostButtonClicked = PublishRelay<Void>()
    private let likePostButtonClicked = PublishRelay<Void>()
    let viewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        navigationItem.title = Constant.Navigation.profile

        collectionView.register(
            ProfilePostCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfilePostCollectionViewCell.identifier
        )
        
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: ProfileViewController.profileSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
    }
}

extension ProfileViewController {
    private func bind() {
        let input = ProfileViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            callProfile: PublishRelay<Void>(),
            callUserPost: userPostButtonClicked,
            callLikePost: likePostButtonClicked
        )
        
        let output = viewModel.transform(input: input)
        
        let dataSource = configureDataSource()
        
        output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Post.self)
            .bind(with: self) { owner, post in
                let viewModel = StoryDetailViewModel()
                viewModel.postId = post.post_id
                owner.navigationController?.pushViewController(StoryDetailViewController(viewModel: viewModel), animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<ProfileSectionModel> {
        return RxCollectionViewSectionedReloadDataSource(configureCell:  { dataSource, collectionView, indexPath, _ in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePostCollectionViewCell.identifier, for: indexPath) as? ProfilePostCollectionViewCell else { return UICollectionViewCell() }
            let data = dataSource[indexPath.section].items[indexPath.item]
            cell.configureData(data)
                return cell
        }) { dataSource, collectionView, kind, indexPath in
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: ProfileViewController.profileSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier, for: indexPath) as? ProfileHeaderView {
                
                header.configureData(dataSource[indexPath.section].header)
                
                header.userPostButton.rx.tap
                    .bind(with: self) { owner, bind in
                        header.userPostButton.configuration?.baseForegroundColor = .black
                        header.likePostButton.configuration?.baseForegroundColor = .dark_gray
                        
                        owner.userPostButtonClicked.accept(())
                        owner.viewModel.selectIndex = 0
                    }
                    .disposed(by: header.disposeBag)
                
                header.likePostButton.rx.tap
                    .bind(with: self) { owner, bind in
                        header.likePostButton.configuration?.baseForegroundColor = .black
                        header.userPostButton.configuration?.baseForegroundColor = .dark_gray
                        
                        owner.likePostButtonClicked.accept(())
                        owner.viewModel.selectIndex = 1
                    
                    }
                    .disposed(by: header.disposeBag)
                
                return header
            }
            
            return UICollectionReusableView()
        }
    }
}

struct ProfileSectionModel {
    var header: ProfileResponse
    var items: [Item]
}

extension ProfileSectionModel: SectionModelType {
    typealias Item = Post
    
    init(original: ProfileSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
