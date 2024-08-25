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
            let urlString = APIURL.sesacBaseURL + "/\(profileImagePath)"
            
            ImageCacheManager.shared.loadImage(urlString: urlString)
                .bind(with: self) { owner, value in
                    if let value {
                        owner.profileView.profileImage.image = value
                    }else {
                        owner.callFetchPostImage(profileImagePath)
                    }
                }
                .disposed(by: disposeBag)
        }else {
            profileView.profileImage.image = UIImage(resource: .profileEmpty)
        }
        
        profileView.nicknameLabel.text = data.nick
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
