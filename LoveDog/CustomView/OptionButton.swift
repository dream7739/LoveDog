//
//  OptionButton.swift
//  LoveDog
//
//  Created by 홍정민 on 8/18/24.
//

import UIKit

final class OptionButton: UIButton {
    
    var isClicked = false {
        didSet {
            if isClicked {
                configuration?.background.backgroundColor = .main
                configuration?.baseForegroundColor = .white
            } else {
                configuration?.background.backgroundColor = .white
                configuration?.baseForegroundColor = .black
            }
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        configuration = ButtonConfiguration.option
        
        var container = AttributeContainer()
        container.font = Design.Font.tertiary
        configuration?.attributedTitle = AttributedString(title, attributes: container)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
