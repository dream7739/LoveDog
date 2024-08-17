//
//  ButtonConfiguration.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

enum ButtonConfiguration {
    static let basic: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .main
        configuration.baseForegroundColor = .white
        var container = AttributeContainer()
        container.font = Design.Font.tertiary
        configuration.attributedTitle = AttributedString("", attributes: container)
        return configuration
    }()
    
    static let floating: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .main
        configuration.baseForegroundColor = .white
        configuration.image = Design.Image.add
        return configuration
    }()

    static let camera: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = Design.Image.camera.applyingSymbolConfiguration(.init(pointSize: 15))
        configuration.cornerStyle = .medium
        configuration.background.strokeColor = .main
        configuration.baseForegroundColor = .dark_gray
        return configuration
    }()
    
    static let delete: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = Design.Image.close.applyingSymbolConfiguration(.init(pointSize: 10))
        configuration.background.backgroundColor = .black
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = .white
        return configuration
    }()
}
