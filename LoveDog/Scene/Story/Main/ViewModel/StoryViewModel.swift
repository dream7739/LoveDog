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
    
    private var profileResponse = ProfileResponse(
        userId: "",
        email: "",
        nick: "",
        profileImage: nil,
        followers: [],
        following: [],
        posts: []
    )
    var postResponse = FetchPostResponse(data: [], next_cursor: "")
    private var cacheResponse = FetchPostResponse(data: [], next_cursor: "")
    private var sectionModel: [StorySectionModel] = []
    private var selectedUser: String = ""
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let selectFollower: PublishRelay<FollowInfo>
        let unselectFollower: PublishRelay<Void>
        let callProfile: PublishRelay<Void>
        let callPost: PublishRelay<Void>
        let callUserPost: PublishRelay<String>
        let prefetch: PublishRelay<Void>
    }
    
    struct Output {
        let sections: BehaviorRelay<[StorySectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let sections =  BehaviorRelay<[StorySectionModel]>(value: [])
        let follower = PublishRelay<[FollowInfo]>()
        let post = PublishRelay<[Post]>()
        
        input.viewWillAppearEvent
            .bind(with: self) { owner, _ in
                owner.selectedUser = ""
                input.callProfile.accept(())
                input.callPost.accept(())
            }
            .disposed(by: disposeBag)
        
        input.prefetch
            .withUnretained(self)
            .filter { _ in
                self.postResponse.next_cursor != "0"
            }
            .map { _ in
                return FetchPostRequest(next: self.postResponse.next_cursor)
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
                    post.accept(self.postResponse.data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.selectFollower
            .debug("SELECTED USER")
            .map { $0.userId }
            .bind(with: self) { owner, value in
                input.callUserPost.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.unselectFollower
            .bind(with: self) { owner, _ in
                owner.postResponse = owner.cacheResponse
                post.accept(owner.postResponse.data)
            }
            .disposed(by: disposeBag)
        
        input.callProfile
            .flatMap { request in
                UserManager.shared.profile()
            }
            .debug("PROFILE")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.profileResponse = value
                    follower.accept(owner.profileResponse.following)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.callPost
            .map { FetchPostRequest(next: "") }
            .flatMap { request in
                PostManager.shared.fetchPostList(request: request)
            }
            .debug("FETCH POST")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    self.postResponse = value
                    self.cacheResponse = value
                    post.accept(self.postResponse.data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.callUserPost
            .map { value in
                return (value, FetchPostRequest(next: ""))
            }
            .flatMap { value in
                PostManager.shared.fetchUserPost(id: value.0, request: value.1)
            }
            .debug("FETCH USER POST")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    self.postResponse = value
                    post.accept(self.postResponse.data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(follower, post)
            .map { follower, post in
                return [
                    StorySectionModel.follower(items: follower.map { StorySectionItem.follower(data: $0) }),
                    StorySectionModel.story(items: post.map { StorySectionItem.story(data: $0) })
                ]
            }
            .debug("SECTION")
            .bind(with: self) { owner, value in
                owner.sectionModel = value
                sections.accept(owner.sectionModel)
            }
            .disposed(by: disposeBag)
        
        return Output(sections: sections)
    }
    
}
