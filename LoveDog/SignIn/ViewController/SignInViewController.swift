//
//  SignInViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit
import RxSwift

final class SignInViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseProvider<LoginService>().callRequest(target: .login(param: LoginRequest(email: "", password: "")), response: LoginResponse.self)
            .subscribe(with: self) { owner, value in
                print(value)
            } onFailure: { owner, error in
                print(error)
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)

    }
    
    
}
