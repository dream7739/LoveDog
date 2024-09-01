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
        static let mini = UIFont.systemFont(ofSize: FontSize.mini)
        
        static let primary_bold = UIFont.boldSystemFont(ofSize: FontSize.primary)
        static let secondary_bold = UIFont.boldSystemFont(ofSize: FontSize.secondary)
        static let tertiary_bold = UIFont.boldSystemFont(ofSize: FontSize.tertiary)
        static let quarternary_bold = UIFont.boldSystemFont(ofSize: FontSize.quarternary)
        
        enum FontSize {
            static let primary: CGFloat = 17
            static let secondary: CGFloat = 15
            static let tertiary: CGFloat = 14
            static let quarternary: CGFloat = 13
            static let mini: CGFloat = 12
        }
    }
    
    enum Image {
        static let comment = UIImage(systemName: "message")!
        static let like = UIImage(systemName: "heart")!
        static let likeFill = UIImage(systemName: "heart.fill")!
        static let add = UIImage(systemName: "plus")!
        static let close = UIImage(systemName: "xmark")!
        static let camera = UIImage(systemName: "camera")!
        static let down = UIImage(systemName: "chevron.down")!
        static let square = UIImage(systemName: "squareshape.split.2x2")!
    }
}

