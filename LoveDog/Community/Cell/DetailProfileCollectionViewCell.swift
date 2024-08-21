//
//  DetailProfileCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import UIKit

final class DetailProfileCollectionViewCell: BaseCollectionViewCell {
    
    private let profileView = FeedProfileView()
    
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
    
}
