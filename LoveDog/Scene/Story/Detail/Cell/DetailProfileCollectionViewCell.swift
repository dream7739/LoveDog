//
//  DetailProfileCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import UIKit
import SnapKit
import RxSwift

final class DetailProfileCollectionViewCell: BaseCollectionViewCell {
    
    let profileView = FeedProfileView()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [profileView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureData(_ data: Creator) {
        if let profileImagePath = data.profileImage {
            let urlString = APIURL.sesacBaseURL + "/\(profileImagePath)"
            
            if let image = ImageCacheManager.shared.loadImage(urlString: urlString) {
                profileView.profileImage.image = image
            } else {
                callFetchPostImage(profileImagePath)
            }
        }else {
            profileView.profileImage.image = UIImage(resource: .profileEmpty)
        }
        
        profileView.nicknameLabel.text = data.nick
        
        if UserDefaultsManager.userId == data.user_id {
            profileView.followButton.isHidden = true
        } else {
            profileView.followButton.isHidden = false
        }
    }
    
    private func callFetchPostImage(_ path: String) {
        PostManager.shared.fetchPostImage(path: path)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.profileView.profileImage.image = value
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
}
