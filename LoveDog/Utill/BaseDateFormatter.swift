//
//  BaseDateFormatter.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation

enum BaseDateFormatter {
    enum DateType: String {
        case yyMMdd = "yy년 MM월 dd일"
    }
    
    static let basicDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()
    
    static let postDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateType.yyMMdd.rawValue
        return dateFormatter
    }()
}
