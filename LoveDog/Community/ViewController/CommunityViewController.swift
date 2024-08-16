//
//  CommunityViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommunityViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = FetchPostRequest(next: "", limit: "5")
        PostManager.shared.fetchPost(request: request)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    dump(value)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

    }
    
}
