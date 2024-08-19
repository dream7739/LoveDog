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
    
    var imageList: [UIImage] = []
    var fileList: [String] = []
    
    lazy var selectedImages = BehaviorRelay(value: imageList)
    lazy var fileNames = BehaviorRelay(value: fileList)

    struct Input {
        let saveTap: ControlEvent<Void>
        let title: ControlProperty<String>
        let content: ControlProperty<String>
    }
    
    struct Output {
        let uploadError: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {

        let uploadError = PublishRelay<String>()
        
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
            .withLatestFrom(Observable.combineLatest(input.title, input.content))
            .debug("CONTENT")
        
        //업로드 이미지
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
        
        //업로드 포스트(제목, 내용, 카테고리)
        Observable.zip(postImage, content)
            .map { value in
                return (images: value.0, title: value.1.0, content: value.1.1)
            }
            .map { value in
                return UploadPostRequest(title: value.title, content: value.content, content1: "입양후기", files: value.images)
            }.flatMap { value in
                PostManager.shared.uploadPost(request: value)
            }
            .debug("POST UPLOAD")
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(uploadError: uploadError)
    }
}

extension MakeStoryViewModel {
    func createImageRequest(image: [UIImage], fileName: [String]) -> [String: Data] {
        var request: [String: Data] = [:]
        
        for (idx, image) in image.enumerated() {
            let imageData = image.pngData()
            let fileName = fileList[idx]
            request[fileName] = imageData
        }
        
        return request
    }
}
