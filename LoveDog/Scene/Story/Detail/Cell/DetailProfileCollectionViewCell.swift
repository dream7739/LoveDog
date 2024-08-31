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
        if let path = data.profileImage {
            let urlString = APIURL.sesacBaseURL + "/\(path)"
            
            ImageCacheManager.shared.loadImage(urlString: urlString, path: path)
                .subscribe(with: self) { owner, value in
                    owner.profileView.profileImage.image = UIImage(data: value)
                } onError: { owner, error in
                    print("LOAD IMAGE ERROR \(error)")
                }
                .disposed(by: disposeBag)
        }
        
        profileView.nicknameLabel.text = data.nick
        
        if UserDefaultsManager.userId == data.user_id {
            profileView.followButton.isHidden = true
        } else {
            profileView.followButton.isHidden = false
        }
    }
    
}
