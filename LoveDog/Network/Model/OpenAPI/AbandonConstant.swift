//
//  AbandonConstant.swift
//  LoveDog
//
//  Created by 홍정민 on 8/25/24.
//

import UIKit

enum SexCode: String {
   case male = "M"
   case female = "F"
   case unknown = "Q"
   
   var name: String {
       switch self {
       case .male:
           return "남"
       case .female:
           return "여"
       case .unknown:
           return "미상"
       }
   }
    
    var color: UIColor {
        switch self {
        case .male:
            return .main.withAlphaComponent(0.1)
        case .female:
            return .pink.withAlphaComponent(0.1)
        case .unknown:
            return .light_gray
        }
    }
}

enum Neuter: String {
    case yes = "Y"
    case no = "N"
    case unknown = "U"
    
    var description: String {
        switch self {
        case .yes:
            return "Y"
        case .no:
            return "N"
        case .unknown:
            return "확인불가"
        }
    }
}
