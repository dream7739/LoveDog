//
//  DetailLikeCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import UIKit

final class DetailLikeCollectionViewCell: BaseCollectionViewCell {
    
    private let likeButton = UIButton()
    private let likeLabel = UILabel()
    private let commentButton = UIButton()
    private let commentLabel = UILabel()
    
    override func configureHierarchy() {
        [likeButton, likeLabel, commentButton, commentLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(13)
            make.size.equalTo(24)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(4)
            make.centerY.equalTo(likeButton)
        }
        
        commentButton.snp.makeConstraints { make in
            make.leading.equalTo(likeLabel.snp.trailing).offset(10)
            make.size.equalTo(20)
            make.centerY.equalTo(likeButton)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentButton.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(15)
            make.centerY.equalTo(commentButton)
        }
    }
    
    override func configureView() {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .black
        likeButton.configuration = configuration
        likeButton.configuration?.image = Design.Image.like
        commentButton.configuration = configuration
        commentButton.configuration?.image = Design.Image.comment
        
        likeLabel.font = Design.Font.tertiary
        likeLabel.textAlignment = .left
        commentLabel.font = Design.Font.tertiary
        commentLabel.textAlignment = .left
    }
    
    func configureData(_ likeCount: String, _ commentCount: String) {
        likeLabel.text = likeCount
        commentLabel.text = commentCount
    }
}
