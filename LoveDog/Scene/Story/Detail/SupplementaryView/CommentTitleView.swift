//
//  CommentTitleView.swift
//  LoveDog
//
//  Created by 홍정민 on 8/25/24.
//

import UIKit
import SnapKit

final class CommentTitleView: UICollectionReusableView {
    let seperatorLabel = UILabel()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(seperatorLabel)
        addSubview(titleLabel)
        
        seperatorLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        seperatorLabel.backgroundColor = .light_gray
        titleLabel.font = Design.Font.tertiary
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitle(_ title: String) {
        titleLabel.text = title
    }
    
}
