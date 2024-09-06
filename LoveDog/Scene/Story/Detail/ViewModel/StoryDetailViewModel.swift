//
//  StoryDetailViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

final class StoryDetailViewModel: BaseViewModel {
    
    var postId = ""
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let callRequest: PublishRelay<Void>
        let followButtonClicked: PublishRelay<Bool>
        let modifyButtonClicked: PublishRelay<Void>
        let deleteButtonClicked: PublishRelay<Void>
        let likeButtonClicked: PublishRelay<Bool>
        let cheerButtonClicked: PublishRelay<Void>
        let cheerPaymentCompleted: PublishRelay<ValidationRequest>
        let commentText: ControlProperty<String>
        let uploadComment: ControlEvent<Void>
    }
    
    struct Output {
        let sections: Observable<[DetailSectionModel]>
        let payment: PublishRelay<IamportPayment>
        let validationResult: PublishRelay<String>
        let deleteSuccess: PublishRelay<Void>
        let deleteFailed: PublishRelay<String>
        let modifyViewModel: PublishRelay<MakeStoryViewModel>
    }
    
    func transform(input: Input) -> Output {
        let postDetail = PublishRelay<Post>()
        let sections: Observable<[DetailSectionModel]>
        let payment = PublishRelay<IamportPayment>()
        let validationResult = PublishRelay<String>()
        let deleteSuccess = PublishRelay<Void>()
        let deleteFailed = PublishRelay<String>()
        let modifyViewModel = PublishRelay<MakeStoryViewModel>()
        let userProfile = PublishRelay<ProfileResponse>()
        
        input.viewWillAppearEvent
            .debug("VIEWWILLAPPEAR")
            .subscribe(with: self) { owner, _ in
                input.callRequest.accept(())
            }
            .disposed(by: disposeBag)
        
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
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
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
        
        //응원하기 버튼 클릭
        input.cheerButtonClicked
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(postDetail)
            .map { value in
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                    merchant_uid: "ios_\(APIKey.sesacKey)_\(Int(Date().timeIntervalSince1970))",
                    amount: "\(value.price ?? 0)")
                payment.pay_method = PayMethod.card.rawValue
                payment.name = value.title
                payment.buyer_name = "홍정민"
                payment.app_scheme = "jm"
                
                return payment
            }
            .debug("PAYMENT")
            .bind(with: self) { owner, value in
                payment.accept(value)
            }
            .disposed(by: disposeBag)
        
        //결제 완료 후 서버 검증
        input.cheerPaymentCompleted
            .flatMap { value in
                PaymentManager.shared.validationPayment(request: value)
            }
            .debug("CHEER PAYMENT COMPLETED")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print(value)
                    validationResult.accept("결제가 완료되었습니다.")
                case .failure(let error):
                    print(error.localizedDescription)
                    validationResult.accept("결제가 실패하였습니다.")
                }
            }
            .disposed(by: disposeBag)
        
        //댓글 버튼 클릭
        input.uploadComment
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
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
        
        //팔로우 버튼 클릭 - 팔로잉
        let follow = input.followButtonClicked
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .filter { $0 }
        
        //팔로우 버튼 클릭 - 언팔로잉
        let unfollow = input.followButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .filter { !$0 }
        
        //팔로잉 서버통신
        follow
            .withLatestFrom(postDetail)
            .flatMap { value in
                PostManager.shared.uploadFollow(id: value.creator.user_id)
            }
            .debug("FOLLOW")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    input.callRequest.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        //언팔로잉 서버통신
        unfollow
            .withLatestFrom(postDetail)
            .flatMap { value in
                PostManager.shared.deleteFollow(id: value.creator.user_id)
            }
            .debug("UNFOLLOW")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    input.callRequest.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        //게시글 삭제 버튼 클릭
        input.deleteButtonClicked
            .withLatestFrom(postDetail)
            .flatMap { value in
                PostManager.shared.deletePost(id: value.post_id)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print(value)
                    deleteSuccess.accept(())
                case .failure(let error):
                    print(error)
                    deleteFailed.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        //게시글 수정 버튼 클릭
        input.modifyButtonClicked
            .withLatestFrom(postDetail)
            .bind(with: self) { owner, value in
                let viewModel = MakeStoryViewModel()
                viewModel.modifyStory = value
                viewModel.viewType = .edit
                modifyViewModel.accept(viewModel)
            }
            .disposed(by: disposeBag)
        
        //나의 포스트일 경우
        let myPost = postDetail
            .filter { $0.creator.user_id == UserDefaultsManager.userId }
            .map { ($0.creator, false) }
            .debug("MY POST")
        
        //다른사람의 포스트일 경우
        //팔로잉 관계를 파악하기 위해 유저 프로필 조회
        postDetail
            .filter { $0.creator.user_id != UserDefaultsManager.userId }
            .flatMap { value in
                UserManager.shared.profile()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    userProfile.accept(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        //다른 사람 포스트일 경우
        let otherPost = Observable.zip(postDetail, userProfile)
            .map { value in
                let creator = value.0.creator
                let isFollowed = value.1.following.filter { $0.userId == value.0.creator.user_id }.count > 0
                return (creator, isFollowed)
            }
            .debug("OHTER POST")
        
        // 프로필 섹션
        let profile = Observable.merge(myPost, otherPost)
            .map { value in
                DetailSectionModel.profile(
                    items: [.profile(data: value.0, isFollowed: value.1)]
                )
            }
            .debug("PROFILE")
        
        //이미지 섹션
        let image = postDetail
            .map { $0.files }
            .map { value in
                return value.map { SectionItem.image(image: $0) }
            }.map {
                DetailSectionModel.image(items: $0)
            }
            .debug("IMAGE")
        
        //좋아요 수
        let likeCount = postDetail
            .map { $0.likes.count }
        
        //댓글 수
        let commentCount = postDetail
            .map { $0.comments.count }
        
        //후원 수
        let cheerCount = postDetail
            .map { value in
                var set = Set<String>()
                value.buyers.forEach {
                    set.insert($0)
                }
                return Array(set)
            }
            .map {
                $0.count
            }
        
        //좋아요 여부
        let isLiked = postDetail
            .map { $0.likes.contains(UserDefaultsManager.userId) }
        
        //좋아요 섹션
        //- 좋아요 여부, 좋아요 수, 댓글 수, 응원 수
        let like = Observable.zip(isLiked, likeCount, commentCount, cheerCount)
            .map { ($0, "\($1)", "\($2)", "\($3)") }
            .map {
                DetailSectionModel.like(
                    items: [.like(isLiked: $0.0, likeCount: $0.1, commentCount: $0.2, cheerCount: $0.3)]
                )
            }
            .debug("LIKE")
        
        //게시글 섹션
        //- 제목, 내용
        let content = postDetail
            .map { ($0.title, $0.content) }
            .map {
                DetailSectionModel.content(
                    items: [.content(title: $0.0, content: $0.1 ?? "")]
                )
            }
            .debug("CONTENT")
        
        //댓글 섹션
        let comment = postDetail
            .map { $0.comments }
            .map { value in
                value.map {
                    SectionItem.comment(comments: $0)
                }
            }
            .map { value in
                DetailSectionModel.comment(items: value)
            }
        
        //전체 섹션
        sections = Observable.zip(profile, image, like, content, comment)
            .map { value in
                let section = [value.0, value.1, value.2, value.3, value.4]
                return section
            }
            .debug("SECTION")
        
        
        return Output(
            sections: sections,
            payment: payment,
            validationResult: validationResult,
            deleteSuccess: deleteSuccess,
            deleteFailed: deleteFailed,
            modifyViewModel: modifyViewModel
        )
    }
}
