//
//  SignInViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: BaseViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let signButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let validationText: Driver<String>
        let validation: Driver<Bool>
        let navigationTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let validationText = PublishRelay<String>()
        let validation = BehaviorRelay<Bool>(value: false)
        let navigationTrigger = PublishRelay<Void>()
        
        let userInput = Observable.combineLatest(input.emailText, input.passwordText)
            .map { (email: $0, password: $1) }
        
        userInput.bind(with: self) { owner, value in
            do {
                let valid = try owner.checkInput(value.email, value.password)
                validation.accept(valid)
            }catch UserInputError.isEmpty {
                validation.accept(false)
                validationText.accept(UserInputError.isEmpty.localizedDescription)
            }catch UserInputError.invalidEmail {
                validation.accept(false)
                validationText.accept(UserInputError.invalidEmail.localizedDescription)
            }catch UserInputError.invalidPassword {
                validation.accept(false)
                validationText.accept(UserInputError.invalidPassword.localizedDescription)
            }
            catch {
                print("Unknown Error Occured")
            }
        }
        .disposed(by: disposeBag)
        
        input.signButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(userInput)
            .flatMap{
                UserManager.shared.login(request: LoginRequest(email: $0, password: $1))
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let value):
                    UserDefaultsManager.token = value.accessToken
                    UserDefaultsManager.refresh = value.refreshToken
                    UserDefaultsManager.userId = value.user_id
                    navigationTrigger.accept(())
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            validationText: validationText.asDriver(onErrorJustReturn: ""),
            validation: validation.asDriver(onErrorJustReturn: false),
            navigationTrigger: navigationTrigger.asDriver(onErrorJustReturn: ())
        )
    }
    
    private func checkInput(_ email: String, _ password: String) throws -> Bool {
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            throw UserInputError.isEmpty
        }else if !email.isValidEmail {
            throw UserInputError.invalidEmail
        }else if password.count < 3 {
            throw UserInputError.invalidPassword
        }
        return true
    }
    
}

extension SignInViewModel {
    private enum UserInputError: Error, LocalizedError {
        case isEmpty
        case invalidEmail
        case invalidPassword
        
        var errorDescription: String? {
            switch self {
            case .isEmpty:
                return "값을 입력해주세요"
            case .invalidEmail:
                return "올바른 이메일 형식이 아닙니다"
            case .invalidPassword:
                return "비밀번호는 3자리 이상입니다"
            }
        }
    }
}
