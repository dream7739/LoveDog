//
//  FloatingButton.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import UIKit

final class FloatingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration = ButtonConfiguration.floating
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
