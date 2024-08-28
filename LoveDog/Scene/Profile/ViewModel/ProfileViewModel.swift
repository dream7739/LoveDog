//
//  ProfileViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: BaseViewModel {
    
    private let disposeBag = DisposeBag()
    
    var selectIndex = 0
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let callProfile: PublishRelay<Void>
        let callUserPost: PublishRelay<Void>
        let callLikePost: PublishRelay<Void>
    }
    
    struct Output {
        let sections: Observable<[ProfileSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let profile = PublishRelay<ProfileResponse>()
        let userPost = PublishRelay<FetchPostResponse>()
        let likePost = PublishRelay<FetchPostResponse>()
        let section: Observable<[ProfileSectionModel]>
         
        input.viewWillAppearEvent
            .throttle(.seconds(30), latest: false, scheduler: MainScheduler.instance)
            .debug("VIEWWILLAPPEAR")
            .subscribe(with: self) { owner, _ in
                input.callProfile.accept(())
                
                if owner.selectIndex == 0 {
                    input.callUserPost.accept(())
                } else {
                    input.callLikePost.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        input.callProfile
            .flatMap {
                UserManager.shared.profile()
            }
            .debug("PROFILE")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    profile.accept(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        input.callUserPost
            .map {
                return FetchPostRequest(next: "", limit: "20")
            }
            .flatMap { value in
                PostManager.shared.fetchUserPost(id: UserDefaultsManager.userId, request: value)
            }
            .debug("USER POST")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    userPost.accept(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.callLikePost
            .map {
                return FetchPostRequest(next: "", limit: "20")
            }
            .flatMap { value in
                PostManager.shared.fetchLikePost(request: value)
            }
            .debug("LIKE POST")
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    likePost.accept(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        let mergePost = Observable.of(userPost, likePost)
            .merge()
            .debug("MERGE TEST")
        
        section = Observable.combineLatest(profile, mergePost)
            .map { value in
                ProfileSectionModel(header: value.0, items: value.1.data)
            }
            .map { return [$0] }
        
        
        return Output(sections: section)
    }
}
