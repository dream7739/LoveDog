//
//  FollowCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FollowCollectionViewCell: BaseCollectionViewCell {
    let profileImage = ProfileImageView()
    private let nicknameLabel = UILabel()

    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        profileImage.image = nil
    }
    
    override func configureHierarchy() {
        [profileImage, nicknameLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(60)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        profileImage.image = UIImage(resource: .profileEmpty)
        nicknameLabel.textAlignment = .center
        nicknameLabel.font = Design.Font.quarternary
    }
    
    func configureData(_ data: FollowInfo) {
        if let profileImagePath = data.profileImage {
            let urlString = APIURL.sesacBaseURL + "/\(profileImagePath)"
            
            if let image = ImageCacheManager.shared.loadImage(urlString: urlString) {
                profileImage.image = image
            } else {
                callFetchPostImage(profileImagePath)
            }
        }else {
            profileImage.image = UIImage(resource: .profileEmpty)
        }
        
        nicknameLabel.text = data.nick
        
        if data.isClicked {
            profileImage.layer.borderColor = UIColor.main.cgColor
            profileImage.layer.borderWidth = 2
        } else {
            profileImage.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
    private func callFetchPostImage(_ path: String) {
        PostManager.shared.fetchPostImage(path: path)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.profileImage.image = value
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
