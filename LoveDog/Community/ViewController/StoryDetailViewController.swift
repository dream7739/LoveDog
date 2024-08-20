//
//  StoryDetailViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class StoryDetailViewController: BaseViewController {
    
    private let viewModel: StoryDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: StoryDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension StoryDetailViewController {
    private func bind() {
        let input = StoryDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
    
        output.postDetail
            .bind(with: self) { owner, post in
                print("응답으로 받은 post", post)
            }
            .disposed(by: disposeBag)
    }
}
