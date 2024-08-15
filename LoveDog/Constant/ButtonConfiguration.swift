//
//  ButtonConfiguration.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

struct ButtonConfiguration {
    private init() { }
    
    static let basic: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .main
        configuration.baseForegroundColor = .white
        var container = AttributeContainer()
        container.font = Design.Font.tertiary
        configuration.attributedTitle = AttributedString("", attributes: container)
        return configuration
    }()

}
