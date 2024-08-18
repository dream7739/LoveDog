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
        let save: ControlEvent<Void>
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        
        input.save
            .withLatestFrom(Observable.zip(selectedImages, fileNames))
            .map { (images, fileNames) in
                var request: [String: Data] = [:]
                
                for (idx, image) in images.enumerated() {
                    let imageData = image.pngData()
                    let fileName = fileNames[idx]
                    request[fileName] = imageData
                }
                
                return request
            }
            .flatMap { value in
                if value.isEmpty {
                    return Single<Result<UploadPostImageResponse, UploadPostImageError>>.never()
                }else {
                    return PostManager.shared.uploadPostImage(images: value)
                }
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
        
        return Output()
    }
}
