//
//  MakeStoryViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import UIKit
import RxSwift
import RxCocoa


final class MakeStoryViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    var viewType: MakeViewType = .add
    var modifyStory: Post?
    var imageList: [UIImage] = []
    var fileList: [String] = []
    lazy var selectedImages = BehaviorRelay(value: imageList)
    lazy var fileNames = BehaviorRelay(value: fileList)

    struct Input {
        let saveTap: ControlEvent<Void>
        let title: ControlProperty<String>
        let content: ControlProperty<String>
        let category: BehaviorRelay<String>
    }
    
    struct Output {
        let uploadSuccess: PublishRelay<Void>
        let uploadError: PublishRelay<String>
        let navigationTitle: BehaviorRelay<String>
        let modifyStory: BehaviorRelay<Post?>
    }
    
    func transform(input: Input) -> Output {
        let uploadSuccess = PublishRelay<Void>()
        let uploadError = PublishRelay<String>()
        let navigationTitle = BehaviorRelay(value: viewType.title)
        let modifyStory = BehaviorRelay<Post?>(value: modifyStory)
        
        //이미지
        let images = input.saveTap
            .withLatestFrom(Observable.zip(selectedImages, fileNames))
            .withUnretained(self)
            .map { _, value in
                self.createImageRequest(image: value.0, fileName: value.1)
            }
            .debug("IMAGE")
        
        //컨텐츠
        let content = input.saveTap
            .withLatestFrom(
                Observable.combineLatest(input.title, input.content, input.category)
            )
            .debug("CONTENT")
        
        //서버통신 - 이미지 업로드
        let postImage = images
            .filter { !$0.isEmpty }
            .flatMap { value in
                PostManager.shared.uploadPostImage(images: value).catch { error in
                    print(error.localizedDescription)
                    return Single<UploadPostImageResponse>.never()
                }
            }.map { value in
                return value.files
            }
            .debug("IMAGE UPLOAD")
        
        let request = Observable.zip(postImage, content)
            .map { value in
                return (
                    images: value.0,
                    title: value.1.0,
                    content: value.1.1,
                    category: value.1.2
                )
            }
            .map { value in
                return UploadPostRequest(
                    title: value.title,
                    content: value.content,
                    content1: value.category,
                    files: value.images
                )
            }
        
        //게시글 작성
        request
            .withUnretained(self)
            .filter { _ in
                self.viewType == .add
            }
            .map { value in
                return value.1
            }
            .flatMap { value in
                PostManager.shared.uploadPost(request: value)
            }
            .debug("POST UPLOAD")
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(let value):
                    print(value)
                    uploadSuccess.accept(())
                case .failure(let error):
                    print(error)
                    uploadError.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        //게시글 수정
        let modifyRequest = request
            .withUnretained(self)
            .filter { _ in
                self.viewType == .edit
            }.map {
                $1
            }
        
        Observable.combineLatest(modifyRequest,
                                 modifyStory.compactMap { $0 }.map { $0.post_id } )
            .flatMap { request, postId in
                PostManager.shared.modifyPost(id: postId, param: request)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    uploadSuccess.accept(())
                case .failure(let error):
                    print(error)
                    uploadError.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
          
        return Output(
            uploadSuccess: uploadSuccess,
            uploadError: uploadError,
            navigationTitle: navigationTitle, 
            modifyStory: modifyStory
        )
    }
}

extension MakeStoryViewModel {
    enum MakeViewType {
        case add
        case edit
        
        var title: String {
            switch self {
            case .add:
                return Constant.Navigation.makeStory
            case .edit:
                return Constant.Navigation.editStory
            }
        }
    }
    
    func createImageRequest(image: [UIImage], fileName: [String]) -> [String: Data] {
        var request: [String: Data] = [:]
        
        for (idx, image) in image.enumerated() {
            let imageData = image.jpegData(compressionQuality: 0.5)
            let fileName = fileList[idx]
            request[fileName] = imageData
        }
        return request
    }
}
