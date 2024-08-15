//
//  BaseViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import Foundation

protocol BaseViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
