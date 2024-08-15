//
//  ProfileViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift

final class ProfileViewController: BaseViewController {
    private let refreshButton = UIButton()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(refreshButton)
        
        refreshButton.backgroundColor = .red
        refreshButton.setTitle("토큰 갱신", for: .normal)
        
        refreshButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        refreshButton.rx.tap
            .flatMap {
                UserManager.shared.refresh()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    UserDefaultsManager.token = value.accessToken
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        UserManager.shared.profile()
            .subscribe(with: self){ owner, result in
                switch result {
                case .success(let value):
                   print(value)
                case .failure(let error):
                   print(error)
                }
            }
            .disposed(by: disposeBag)


    }
    
}
