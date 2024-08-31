//
//  ImageCacheManager.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import Foundation
import RxSwift


final class Cachable {
    let imageData: Data
    let eTag: String?
    
    init(imageData: Data, eTag: String? = nil) {
        self.imageData = imageData
        self.eTag = eTag
    }
}

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache: NSCache<NSString, Cachable>
    private let disposeBag = DisposeBag()
    
    private init() {
        cache = NSCache<NSString, Cachable>()
        cache.totalCostLimit = 1024 * 1024 * 50 //50MB 제한
    }
    
    //Etag 지원하지 않는 OpenAPI
    func loadImage(urlString: String) -> Observable<Data> {
        guard let url = URL(string: urlString) else {
            return Observable.error(APIError.invalidURL)
        }
        
        if let cachedImage = cachedImage(url: url) {
            print("OPENAPI - 캐시에 이미지 존재")
            return Observable.just(cachedImage.imageData)
        }
        
        if let diskImage = cachedDiskImage(url: url) {
            print("OPENAPI - 디스크에 이미지 존재")
            return Observable.just(diskImage.imageData)
        }
        
        print("OPENAPI - 서버에서 이미지 가져옴")
        let serverImage = callFetchAbaondonImage(urlString: urlString)
        return serverImage
    }
    
    //Etag 지원하는 LSLP API
    func loadImage(urlString: String, path: String = "") -> Observable<Data> {
        
        guard let url = URL(string: urlString) else {
            return Observable.error(APIError.invalidURL)
        }
        
        if let image = cachedImage(url: url) {
            print("LSLP - CACHE에 이미지 존재")
            return callFetchPostImageWithEtag(path: path, cachable: image)
        }
        
        if let diskImage = cachedDiskImage(url: url) {
            print("LSLP - DISK에 이미지 존재")
            return callFetchPostImageWithEtag(path: path, cachable: diskImage)
        }
        
        print("LSLP - 서버에서 이미지 가져옴")
        let serverImage = callFetchPostImage(path: path)
        return serverImage
    }
    
    // NSCache
    func cachingImage(url: URL, cachable: Cachable) {
        let key = url.path as NSString
        cache.setObject(cachable, forKey: key, cost: cachable.imageData.count)
    }
    
    private func cachedImage(url: URL) -> Cachable? {
        let key = url.path as NSString
        return cache.object(forKey: key)
    }
    
    // FileManager
    func cachingDiskImage(url: URL, cachable: Cachable) {
        guard let fileURL = createFilePath(url: url) else { return }
        
        do {
            try cachable.imageData.write(to: fileURL)
            UserDefaultsManager.etag[fileURL.lastPathComponent] = cachable.eTag
        } catch {
            print("FILE SAVE ERROR")
        }
        return
    }
    
    private func cachedDiskImage(url: URL) -> Cachable? {
        guard let fileURL = createFilePath(url: url) else { return nil }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            guard let data = try? Data(contentsOf: fileURL) else { return nil }
            let cachable = Cachable(imageData: data, eTag: UserDefaultsManager.etag[fileURL.lastPathComponent])
            cachingImage(url: url, cachable: cachable)
            return cachable
        } else {
            return nil
        }
    }
    
    private func createFilePath(url: URL) -> URL? {
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        var fileURL = URL(fileURLWithPath: directoryPath)
        fileURL.appendPathComponent(url.lastPathComponent)
        print("FILEURL \(fileURL)")
        return fileURL
    }
    
}

extension ImageCacheManager {
    private func callFetchPostImage(path: String) 
    -> Observable<Data> {
        return Observable<Data>.create { observer in
            PostManager.shared.fetchPostImage(path: path)
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func callFetchPostImageWithEtag(path: String, cachable: Cachable)
    -> Observable<Data> {
        return Observable<Data>.create { observer in
            PostManager.shared.fetchPostImage(path: path, etag: cachable.eTag)
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        if error.self == .existImage {
                            print(error.localizedDescription)
                            observer.onNext(cachable.imageData)
                            observer.onCompleted()
                        }
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
    }
    
    private func callFetchAbaondonImage(urlString: String) -> Observable<Data> {
        return Observable<Data>.create { observer in
            
            OpenAPIManager.shared.fetchAbondonPublicImage(urlString)
                .subscribe(with: self){ owner, result in
                    switch result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
