//
//  BasicButton.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

final class BasicButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        configuration = ButtonConfiguration.basic
        configuration?.title = title
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
