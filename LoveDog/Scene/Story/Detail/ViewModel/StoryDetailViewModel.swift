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
    let followButtonClicked = PublishRelay<Void>()
    let likeButtonClicked = PublishRelay<Bool>()
    
    private var post: Post?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let uploadComment: ControlEvent<Void>
        let commentContent: ControlProperty<String>
    }
    
    struct Output {
        let sections: Observable<[MultipleSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let sections: Observable<[MultipleSectionModel]>
        let postDetail = PublishRelay<Post>()
        
        postId
            .flatMap { id in
                PostManager.shared.fetchPost(id: id)
            }
            .debug("POSTID")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.post = value
                    postDetail.accept(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        let likeClick = likeButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
        
        Observable.zip(postId, likeClick)
            .filter { !$0.0.isEmpty }
            .flatMap { value in
                PostManager.shared.uploadLike(id: value.0, request: Like(like_status: value.1))
            }
            .debug("LIKE CLICK")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    if value.like_status {
                        if let post = owner.post, !post.likes.contains(UserDefaultsManager.userId) {
                            owner.post?.likes.append(UserDefaultsManager.userId)
                        }
                        if let post = owner.post {
                            postDetail.accept(post)
                        }
                    } else {
                        owner.post?.likes.removeAll { $0 == UserDefaultsManager.userId }
                        
                        if let post = owner.post {
                            postDetail.accept(post)
                        }
                    }
                    
                    if let id = owner.post?.post_id {
                        owner.postId.accept(id)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        let profile = postDetail
            .map {
                MultipleSectionModel.profile(
                    items: [.profile(data: $0.creator)]
                )
            }
            .debug("PROFILE")
    
        let image = postDetail
            .map { $0.files }
            .map { value in
                return value.map { SectionItem.image(image: $0) }
            }.map {
                MultipleSectionModel.image(items: $0)
            }
            .debug("IMAGE")
        
        let likeCount = postDetail
            .map { $0.likes.count }
        
        let commentCount = postDetail
            .map { $0.comments.count }
        
        let isLiked = postDetail
            .map { $0.likes.contains(UserDefaultsManager.userId) }
        
        let like = Observable.zip(isLiked, likeCount, commentCount)
            .map { ($0, "\($1)", "\($2)") }
            .map {
                MultipleSectionModel.like(
                    items: [.like(isLiked: $0.0, likeCount: $0.1, commentCount: $0.2)]
                )
            }
            .debug("LIKE")
            
        let content = postDetail
            .map { ($0.title, $0.content) }
            .map {
                MultipleSectionModel.content(
                    items: [.content(title: $0.0, content: $0.1 ?? "")]
                )
            }
            .debug("CONTENT")
        
        let comment = postDetail
            .map { $0.comments }
            .map { value in
                value.map {
                    SectionItem.comment(comments: $0)
                }
            }
            .map { value in
                MultipleSectionModel.comment(items: value)
            }
        
       sections = Observable.zip(profile, image, like, content, comment)
            .withUnretained(self)
            .map { _, value in
                let section = [value.0, value.1, value.2, value.3, value.4]
                return section
            }
        
        let postComment = input.uploadComment
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.commentContent)
            .filter { value in
                !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
           
       Observable.zip(postId, postComment)
            .flatMap { id, content in
                PostManager.shared.uploadComments(id: id, request: UploadCommentsRequest(content: content))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    if let id = owner.post?.post_id {
                        owner.postId.accept(id)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        followButtonClicked
            .withLatestFrom(postDetail)
            .flatMap { value in
                PostManager.shared.uploadFollow(id: value.creator.user_id)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    
        
        return Output(sections: sections)
    }
}
