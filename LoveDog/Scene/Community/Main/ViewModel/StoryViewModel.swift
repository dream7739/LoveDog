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
        let postList: BehaviorRelay<[Post]>
    }
    
    func transform(input: Input) -> Output {
        let postList = BehaviorRelay(value: postResponse.data)
        
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
        
//        input.request
//            .subscribe(with: self) { owner, value in
//                postList.accept(StoryViewModel.testList)
//            }
//            .disposed(by: disposeBag)
        
      
        return Output(postList: postList)
    }
    
}

extension StoryViewModel {
    static let testList: [Post] = [
        Post(
            post_id: "12341234",
            product_id: "luvdog_community",
            title: "루피공주",
            content: "루피공주",
            content1: "입양홍보",
            createdAt: "2024-08-20T13:54:09.939Z",
            creator: Creator(user_id: "12341234", nick: "스폰지밥홍", profileImage: nil),
            files: [],
            likes: ["111", "2222", "33333"],
            likes2: [],
            hashTags: [],
            comments: [
                Comment(comment_id: "12341234", content: "역시 루피 귀엽", createdAt: "2024-08-20T13:54:09.939Z", creator: Creator(user_id: "12341234", nick: "징징이홍", profileImage: nil)),
                Comment(comment_id: "12341234", content: "역시 루피 귀엽2", createdAt: "2024-08-20T13:54:09.939Z", creator: Creator(user_id: "12341234", nick: "징징이홍", profileImage: nil)),
                Comment(comment_id: "12341234", content: "역시 루피 귀엽3", createdAt: "2024-08-20T13:54:09.939Z", creator: Creator(user_id: "12341234", nick: "징징이홍", profileImage: nil)),
                      ]
        ),
        Post(
            post_id: "12341234",
            product_id: "luvdog_community",
            title: "루피공주",
            content: "루피공주",
            content1: "입양홍보",
            createdAt: "2024-08-20T13:54:09.939Z",
            creator: Creator(user_id: "12341234", nick: "스폰지밥홍", profileImage: nil),
            files: [],
            likes: [],
            likes2: [],
            hashTags: [],
            comments: [Comment(comment_id: "12341234", content: "역시 루피 귀엽", createdAt: "2024-08-20T13:54:09.939Z", creator: Creator(user_id: "12341234", nick: "징징이홍", profileImage: nil))]
        ),
        Post(
            post_id: "12341234",
            product_id: "luvdog_community",
            title: "루피공주",
            content: "루피공주",
            content1: "입양홍보",
            createdAt: "2024-08-20T13:54:09.939Z",
            creator: Creator(user_id: "12341234", nick: "스폰지밥홍", profileImage: nil),
            files: [],
            likes: [],
            likes2: [],
            hashTags: [],
            comments: [Comment(comment_id: "12341234", content: "역시 루피 귀엽", createdAt: "2024-08-20T13:54:09.939Z", creator: Creator(user_id: "12341234", nick: "징징이홍", profileImage: nil))]
        ),
        Post(
            post_id: "12341234",
            product_id: "luvdog_community",
            title: "루피공주",
            content: "루피공주",
            content1: "입양홍보",
            createdAt: "2024-08-20T13:54:09.939Z",
            creator: Creator(user_id: "12341234", nick: "스폰지밥홍", profileImage: nil),
            files: [],
            likes: [],
            likes2: [],
            hashTags: [],
            comments: [Comment(comment_id: "12341234", content: "역시 루피 귀엽", createdAt: "2024-08-20T13:54:09.939Z", creator: Creator(user_id: "12341234", nick: "징징이홍", profileImage: nil))]
        ),
        Post(
            post_id: "12341234",
            product_id: "luvdog_community",
            title: "루피공주",
            content: "루피공주",
            content1: "입양홍보",
            createdAt: "2024-08-20T13:54:09.939Z",
            creator: Creator(user_id: "12341234", nick: "스폰지밥홍", profileImage: nil),
            files: [],
            likes: [],
            likes2: [],
            hashTags: [],
            comments: [Comment(comment_id: "12341234", content: "역시 루피 귀엽", createdAt: "2024-08-20T13:54:09.939Z", creator: Creator(user_id: "12341234", nick: "징징이홍", profileImage: nil))]
        )
        
    ]
}
