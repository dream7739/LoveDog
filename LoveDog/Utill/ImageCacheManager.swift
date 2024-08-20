//
//  ImageCacheManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import UIKit
import RxSwift

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() { }
    
    private let cache = NSCache<NSURL, UIImage>()
    
    func loadImage(path: String) -> Observable<UIImage?> {
        let urlString = APIURL.sesacBaseURL + "/\(path)"
        guard let url = URL(string: urlString) else {
            return Observable.just(nil)
        }
        
        if let image = cachedImage(url: url) {
            return Observable.just(image)
        }
        
        return callFetchPostImage(url: url, path: path)
        
    }
    
    private func callFetchPostImage(url: URL, path: String) -> Observable<UIImage?> {
        Observable<UIImage?>.create { observer in
            PostManager.shared.fetchPostImage(path: path)
                .debug("이미지 없어용")
                .subscribe(with: self){ owner, result in
                    switch result {
                    case .success(let value):
                        owner.cachingImage(url: url, image: value)
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        print(error)
                        observer.onNext(nil)
                    }
                }
            
        }
    }
    
    private func cachingImage(url: URL, image: UIImage?) {
        print("이미지 저장", url)
        guard let image = image else { return }
        cache.setObject(image, forKey: url as NSURL)
    }
    
    private func cachedImage(url: URL) -> UIImage? {
        print("저장된 이미지", url)
        return cache.object(forKey: url as NSURL)
    }
    
}
