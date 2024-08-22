//
//  IntroduceViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift

final class IntroduceViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OpenAPIManager.shared.fetchAbondonPublic(request: FetchAbandonRequest(pageNo: 1, pageCnt: 20))
            .subscribe { result in
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
