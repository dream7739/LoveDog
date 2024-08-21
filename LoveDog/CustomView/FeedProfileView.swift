//
//  FeedProfileView.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import UIKit
import SnapKit

final class FeedProfileView: BaseView {
    let profileImage = UIImageView()
    let nicknameLabel = UILabel()
    let followButton = UIButton()
    
    override func configureHierarchy() {
        [profileImage, nicknameLabel, followButton]
            .forEach {
                addSubview($0)
            }
    }
    
    override func configureLayout() {
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.equalTo(followButton.snp.leading).offset(-8)
            make.centerY.equalTo(profileImage)
        }
        
        followButton.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailing).offset(-10)
            make.height.equalTo(35)
            make.centerY.equalTo(profileImage)
        }
    }
    
    override func configureView() {
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.image = UIImage(resource: .profileEmpty)
        
        nicknameLabel.font = Design.Font.tertiary_bold
        
        followButton.configuration = ButtonConfiguration.basic
        followButton.configuration?.title = "팔로우"
    }
}
