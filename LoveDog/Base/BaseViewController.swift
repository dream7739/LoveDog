//
//  BaseViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureNav() { 
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
}
