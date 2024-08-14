//
//  ReusableProtocol.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

protocol ReusableProtocol: AnyObject {
    static var identifier: String { get }
}

extension UIView: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
