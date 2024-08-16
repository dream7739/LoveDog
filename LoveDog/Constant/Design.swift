//
//  Design.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

enum Design {
    enum Font {
        static let primary = UIFont.systemFont(ofSize: FontSize.primary)
        static let secondary = UIFont.systemFont(ofSize: FontSize.secondary)
        static let tertiary = UIFont.systemFont(ofSize: FontSize.tertiary)
        static let quarternary = UIFont.systemFont(ofSize: FontSize.quarternary)
        
        enum FontSize {
            static let primary: CGFloat = 17
            static let secondary: CGFloat = 15
            static let tertiary: CGFloat = 14
            static let quarternary: CGFloat = 13
        }
    }
    
    enum Image {
        static let comment = UIImage(systemName: "message")!
        static let like = UIImage(systemName: "heart")!
        static let add = UIImage(systemName: "plus")!
    }
}

