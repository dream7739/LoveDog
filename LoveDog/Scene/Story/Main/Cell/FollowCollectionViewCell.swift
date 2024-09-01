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
    
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                profileImage.layer.borderColor = UIColor.main.cgColor
                profileImage.layer.borderWidth = 2
            } else {
                profileImage.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    override func prepareForReuse() {
        print(#function)
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
        if let path = data.profileImage {
            let urlString = APIURL.sesacBaseURL + "/\(path)"
            
            ImageCacheManager.shared.loadImage(urlString: urlString, path: path)
                .observe(on: MainScheduler.instance)
                .subscribe(with: self) { owner, value in
                    owner.profileImage.setImage(data: value, size: owner.profileImage.bounds.size)
                } onError: { owner, error in
                    print("LOAD IMAGE ERROR \(error)")
                }
                .disposed(by: disposeBag)
        }
        
        nicknameLabel.text = data.nick
        
    }
    
    
}
