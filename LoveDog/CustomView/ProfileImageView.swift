//
//  ProfileImageView.swift
//  LoveDog
//
//  Created by 홍정민 on 8/26/24.
//

import UIKit

final class ProfileImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
}
