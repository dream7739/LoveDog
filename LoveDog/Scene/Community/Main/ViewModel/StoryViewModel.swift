//
//  StoryViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class StoryViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    var postResponse = FetchPostResponse(data: [], next_cursor: "")

    struct Input {
        let request: BehaviorRelay<FetchPostRequest>
        let prefetch: PublishRelay<Void>
    }
    
    struct Output {
        let postList: PublishRelay<[Post]>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishRelay<[Post]>()
        
        input.prefetch
            .withUnretained(self)
            .filter { _ in
                self.postResponse.next_cursor != "0"
            }
            .map { _ in
                FetchPostRequest(next: self.postResponse.next_cursor)
            }
            .flatMap { request in
                PostManager.shared.fetchPostList(request: request)
            }
            .debug("PREFETCH POST")
            .subscribe { result in
                switch result {
                case .success(let value):
                    self.postResponse.next_cursor = value.next_cursor
                    self.postResponse.data.append(contentsOf: value.data)
                    postList.accept(self.postResponse.data)
                case .failure(let error):
                    print(error.localizedDescription)
                }           
            }
            .disposed(by: disposeBag)
        
        
        input.request
            .flatMap { request in
                PostManager.shared.fetchPostList(request: request)
            }
            .debug("FETCH POST")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.postResponse = value
                    postList.accept(owner.postResponse.data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(postList: postList)
    }
    
}
