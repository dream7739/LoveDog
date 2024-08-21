//
//  DetailProfileCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import UIKit
import RxSwift

final class DetailProfileCollectionViewCell: BaseCollectionViewCell {
    
    private let profileView = FeedProfileView()
    
    private let disposeBag = DisposeBag()
    
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
            ImageCacheManager.shared.loadImage(path: profileImagePath)
                .bind(with: self) { owner, value in
                    if let image = value {
                        owner.profileView.profileImage.image = value
                    }else {
                        owner.profileView.profileImage.image = UIImage(resource: .profileEmpty)
                    }
                }
                .disposed(by: disposeBag)
        }else {
            profileView.profileImage.image = UIImage(resource: .profileEmpty)
        }
        
        profileView.nicknameLabel.text = data.nick
    }
    
}
