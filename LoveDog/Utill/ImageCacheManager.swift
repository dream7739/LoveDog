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
    private let disposeBag = DisposeBag()
    
    func loadImage(urlString: String) -> Observable<UIImage?> {
        guard let url = URL(string: urlString) else {
            return Observable.just(nil)
        }
        
        if let image = cachedImage(url: url) {
            print("저장된 이미지 있음")
            return Observable.just(image)
        }
        
        return Observable.just(nil)
    }
    
    func cachingImage(url: URL, image: UIImage?) {
        guard let image = image else { return }
        cache.setObject(image, forKey: url as NSURL)
    }
    
    private func cachedImage(url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
}
