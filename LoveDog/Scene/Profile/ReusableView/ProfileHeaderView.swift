//
//  ProfileHeaderView.swift
//  LoveDog
//
//  Created by 홍정민 on 8/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileHeaderView: UICollectionReusableView {
    private let profileImage = ProfileImageView()
    private let nicknameLabel = UILabel()
    private let infoStackView = UIStackView()
    private let postCountButton = UIButton()
    private let followerButton = UIButton()
    private let followingButton = UIButton()
    private let contentStackView = UIStackView()
    let userPostButton = UIButton()
    let likePostButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [profileImage, nicknameLabel, infoStackView, contentStackView]
            .forEach {
                addSubview($0)
            }
        
        [postCountButton, followerButton, followingButton]
            .forEach {
                infoStackView.addArrangedSubview($0)
            }
        
        [userPostButton, likePostButton]
            .forEach {
                contentStackView.addArrangedSubview($0)
            }
    }
    
    private func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(15)
            make.top.equalTo(safeAreaLayoutGuide).inset(15)
            make.size.equalTo(70)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.leading.equalTo(profileImage)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    private func configureView() {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .black
        configuration.titleAlignment = .center
        
        infoStackView.axis = .horizontal
        infoStackView.spacing = 10
        infoStackView.distribution = .fillEqually
    
        postCountButton.configuration = configuration
        postCountButton.configuration?.subtitle = "게시물"
        
        followerButton.configuration = configuration
        followerButton.configuration?.subtitle = "팔로워"
        
        followingButton.configuration = configuration
        followingButton.configuration?.subtitle = "팔로잉"
        
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fillEqually
        
        userPostButton.configuration = configuration
        userPostButton.configuration?.image = Design.Image.square
        
        likePostButton.configuration = configuration
        likePostButton.configuration?.image = Design.Image.like
        likePostButton.configuration?.baseForegroundColor = .dark_gray
    }
    
    func configureData(_ data: ProfileResponse) {
        if let path = data.profileImage {
            let urlString = APIURL.sesacBaseURL + "/\(path)"
            
            ImageCacheManager.shared.loadImage(urlString: urlString, path: path)
                .subscribe(with: self) { owner, value in
                    owner.profileImage.image = UIImage(data: value)
                } onError: { owner, error in
                    print("LOAD IMAGE ERROR \(error)")
                }
                .disposed(by: disposeBag)
        }
        
        nicknameLabel.text = data.nick
        nicknameLabel.textAlignment = .left
        nicknameLabel.font = Design.Font.tertiary_bold
        
        postCountButton.configuration?.title = "\(data.posts.count)"
        followerButton.configuration?.title = "\(data.followers.count)"
        followingButton.configuration?.title = "\(data.following.count)"
    }
    
//    private func callFetchPostImage(_ path: String) {
//        PostManager.shared.fetchPostImage(path: path)
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case .success(let value):
//                    owner.profileImage.image = value
//                case .failure(let error):
//                    print(error)
//                }
//            }
//            .disposed(by: disposeBag)
//    }
}
