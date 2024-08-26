//
//  SignInViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SignInViewController: BaseViewController {
    
    private let emailTextField = BasicTextField()
    private let passwordTextField = BasicTextField()
    private let validationLabel = UILabel()
    private let signInButton = UIButton()
    
    let viewModel = SignInViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
    }
    
    override func configureHierarchy() {
        [emailTextField, passwordTextField, signInButton, validationLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(passwordTextField.snp.top).offset(-8)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.9)
        }
        
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(passwordTextField)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(validationLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        navigationItem.title = "로그인"
        
        emailTextField.font = Design.Font.tertiary
        emailTextField.placeholder = "이메일을 입력해주세요"
        passwordTextField.font = Design.Font.tertiary
        passwordTextField.placeholder = "비밀번호를 입력해주세요"
        passwordTextField.isSecureTextEntry = true
        validationLabel.font = Design.Font.quarternary
        validationLabel.textColor = .deep_gray
        signInButton.isEnabled = false
        signInButton.configuration = ButtonConfiguration.basic
        signInButton.configuration?.title = "로그인"
        
        //TEST
        emailTextField.text = "jm123@naver.com"
        passwordTextField.text = "123"
    }
    
    private func bind() {
        let input = SignInViewModel.Input(
            emailText: emailTextField.rx.text.orEmpty,
            passwordText: passwordTextField.rx.text.orEmpty,
            signButtonTap: signInButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.validationText
            .drive(with: self) { owner, value in
                owner.validationLabel.text = value
            }
            .disposed(by: disposeBag)
        
        output.validation
            .drive(with: self) { owner, value in
                let color: UIColor = value ? .main : .light_gray
                owner.validationLabel.isHidden = value
                owner.signInButton.isEnabled = value
                owner.signInButton.configuration?.background.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        output.navigationTrigger
            .drive(with: self) { owner, value in
                SceneManager.transitionScene(TabBarController())
            }
            .disposed(by: disposeBag)
    }
    
}
