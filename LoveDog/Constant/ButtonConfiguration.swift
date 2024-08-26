//
//  ButtonConfiguration.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

enum ButtonConfiguration {
    //기본 버튼
    static let basic: UIButton.Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = .main
        configuration.baseForegroundColor = .white
        return configuration
    }()
    
    //삭제 버튼
    static let delete: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = Design.Image.close.applyingSymbolConfiguration(.init(pointSize: 10))
        configuration.background.backgroundColor = .black
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = .white
        return configuration
    }()
    
    //옵션 선택 버튼
    static let option: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .capsule
        configuration.background.strokeColor = .main
        configuration.background.strokeWidth = 1
        return configuration
    }()
}
