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
                    postDetail.accept(value)
                case .failure(let error):
                    print(error)
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
        
        let like = Observable.zip(likeCount, commentCount)
            .map { ("\($0)", "\($1)") }
            .map {
                MultipleSectionModel.like(
                    items: [.like(likeCount: $0.0, commentCount: $0.1)]
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
        
        sections = Observable.zip(profile, image, like, content)
            .map { value in
                return [value.0, value.1, value.2, value.3]
            }
            .debug("SECTION")
        
        return Output(sections: sections)
    }
}
