//
//  IntroduceDetailViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class IntroduceDetailViewController: BaseViewController {
    
    
    
    let viewModel = IntroduceDetailViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        
    }

}

extension IntroduceDetailViewController {
    private func bind() {
        let input = IntroduceDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.fetchAbandonItem
            .bind(with: self) { owner, value in
                dump(value)
            }
            .disposed(by: disposeBag)
    }
}
