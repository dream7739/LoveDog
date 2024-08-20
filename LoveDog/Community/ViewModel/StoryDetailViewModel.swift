//
//  StoryDetailViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class StoryDetailViewModel: BaseViewModel {
    
    let postId = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let postDetail: PublishRelay<Post>
    }
    
    func transform(input: Input) -> Output {
        let postDetail = PublishRelay<Post>()
        
//        postId
//            .flatMap { id in
//                PostManager.shared.fetchPost(id: id)
//            }
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case .success(let value):
//                    postDetail.accept(value)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//            .disposed(by: disposeBag)
        
        return Output(postDetail: postDetail)
    }
}
