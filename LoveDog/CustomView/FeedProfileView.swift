//
//  FeedProfileView.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import UIKit
import SnapKit

final class FeedProfileView: BaseView {
    let profileImage = ProfileImageView()
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
            make.height.equalTo(30)
            make.centerY.equalTo(profileImage)
        }
    }
    
    override func configureView() {
        profileImage.image = UIImage(resource: .profileEmpty)
        
        nicknameLabel.font = Design.Font.tertiary_bold
        
        followButton.configuration = ButtonConfiguration.basic
        var container = AttributeContainer()
        container.font = Design.Font.secondary_bold
        followButton.configuration?.attributedTitle = AttributedString("팔로우", attributes: container)
    }
}
