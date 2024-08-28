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
    
    var postId = ""
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let callRequest: BehaviorRelay<Void>
        let followButtonClicked: PublishRelay<Void>
        let likeButtonClicked: PublishRelay<Bool>
        let commentText: ControlProperty<String>
        let uploadComment: ControlEvent<Void>
    }
    
    struct Output {
        let sections: Observable<[MultipleSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let postDetail = PublishRelay<Post>()
        let sections: Observable<[MultipleSectionModel]>
        
        //네트워크 통신
        input.callRequest
            .withUnretained(self)
            .flatMap { _ in
                PostManager.shared.fetchPost(id: self.postId)
            }
            .debug("CALL REQUEST")
            .subscribe { result in
                switch result {
                case .success(let value):
                    postDetail.accept(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        //좋아요 버튼 클릭
        input.likeButtonClicked
            .withUnretained(self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { value in
                return (id: self.postId, status: value.1)
            }
            .flatMap { value in
                PostManager.shared.uploadLike(id: value.id, request: Like(like_status: value.status))
            }
            .debug("LIKE CLICK")
            .subscribe { result in
                switch result {
                case .success:
                    input.callRequest.accept(())
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        //댓글 전송 버튼 클릭
        input.uploadComment
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.commentText)
            .filter { value in
                !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            .withUnretained(self)
            .map { value in
                return (id: self.postId, content: value.1)
            }
            .flatMap { value in
                PostManager.shared.uploadComments(id: value.id, request: UploadCommentsRequest(content: value.content))
            }
            .subscribe { result in
                switch result {
                case .success:
                    input.callRequest.accept(())
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        
        //팔로우 버튼 클릭
        input.followButtonClicked
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

        //게시글 - 프로필
        let profile = postDetail
            .map {
                MultipleSectionModel.profile(
                    items: [.profile(data: $0.creator)]
                )
            }
            .debug("PROFILE")
    
        //게시글 - 이미지
        let image = postDetail
            .map { $0.files }
            .map { value in
                return value.map { SectionItem.image(image: $0) }
            }.map {
                MultipleSectionModel.image(items: $0)
            }
            .debug("IMAGE")
        
        //좋아요 수
        let likeCount = postDetail
            .map { $0.likes.count }
        
        //댓글 수
        let commentCount = postDetail
            .map { $0.comments.count }
        
        //좋아요 여부
        let isLiked = postDetail
            .map { $0.likes.contains(UserDefaultsManager.userId) }
        
        //게시글 - 좋아요 댓글
        let like = Observable.zip(isLiked, likeCount, commentCount)
            .map { ($0, "\($1)", "\($2)") }
            .map {
                MultipleSectionModel.like(
                    items: [.like(isLiked: $0.0, likeCount: $0.1, commentCount: $0.2)]
                )
            }
            .debug("LIKE")
        
        //게시글 - 제목, 내용
        let content = postDetail
            .map { ($0.title, $0.content) }
            .map {
                MultipleSectionModel.content(
                    items: [.content(title: $0.0, content: $0.1 ?? "")]
                )
            }
            .debug("CONTENT")
        
        //게시글 - 댓글
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
        
        //전체 섹션
       sections = Observable.zip(profile, image, like, content, comment)
            .map { value in
                let section = [value.0, value.1, value.2, value.3, value.4]
                return section
            }
            .debug("SECTION")
        
 
        return Output(sections: sections)
    }
}
