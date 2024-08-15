//
//  SignTextField.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

final class BasicTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        layer.borderColor = UIColor.light_gray.cgColor
        layer.borderWidth = 1.0
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftViewMode = .always
        clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
