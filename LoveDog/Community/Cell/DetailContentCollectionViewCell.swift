//
//  DetailContentCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import UIKit

final class DetailContentCollectionViewCell: BaseCollectionViewCell {
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    override func configureHierarchy() {
        [titleLabel, contentLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleLabel)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func configureView() {
        titleLabel.text = "랄랄랄라라라라라라랄"
        contentLabel.text = "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfadsfaasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfadsfaasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfadsfaasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfadsfaasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfadsfa"

        titleLabel.font = Design.Font.primary_bold
        titleLabel.numberOfLines = 2
        
        contentLabel.font = Design.Font.secondary
        contentLabel.numberOfLines = 0
    }
    
}
