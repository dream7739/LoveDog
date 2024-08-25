//
//  BaseDateFormatterManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation

enum BaseDateFormatterManager {
    enum DateType: String {
        case yyMMdd = "yy년 MM월 dd일"
        case yyMMddShort = "yy.M.d"
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
    
    static let shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateType.yyMMddShort.rawValue
        return dateFormatter
    }()
}
