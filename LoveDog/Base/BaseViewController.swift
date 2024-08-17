//
//  BaseViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

class BaseViewController: UIViewController, BaseProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
}
