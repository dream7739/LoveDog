//
//  PaddingLabel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import UIKit

final class PaddingLabel: UILabel {
    private let padding = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += (padding.top + padding.bottom)
        size.width += (padding.left + padding.right)
        return size
    }
    
    func makeLightGrayRound() {
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.deep_gray.withAlphaComponent(0.2).cgColor
        layer.cornerRadius = 6
        clipsToBounds = true
        font = Design.Font.mini
        textColor = .deep_gray
        backgroundColor = .white
    }
    
    func makeBlueBackground() {
        layer.borderWidth = 0.8
        layer.cornerRadius = 6
        clipsToBounds = true
        font = Design.Font.mini
        textColor = .white
        backgroundColor = .main
    }
    
    func makeBasicRound() {
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
