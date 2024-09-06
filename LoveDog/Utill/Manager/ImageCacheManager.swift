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
    private let maxDiskLimit = 1024 * 1024 * 50
    
    private init() {
        cache = NSCache<NSString, Cachable>()
        cache.totalCostLimit = 1024 * 1024 * 50
    }
    
    //Etag 지원하지 않는 OpenAPI
    func loadImage(urlString: String) -> Observable<Data> {
        guard let url = URL(string: urlString) else {
            return Observable.error(APIError.invalidURL)
        }
        
        if let cachedImage = cachedImage(url: url) {
            return Observable.just(cachedImage.imageData)
        }
        
        if let diskImage = cachedDiskImage(url: url) {
            cachingImage(url: url, cachable: diskImage)
            return Observable.just(diskImage.imageData)
        }
        
        let serverImage = callFetchAbaondonImage(urlString: urlString)
        return serverImage
    }
    
    //Etag 지원하는 LSLP API
    func loadImage(urlString: String, path: String = "") -> Observable<Data> {
        
        guard let url = URL(string: urlString) else {
            return Observable.error(APIError.invalidURL)
        }
        
        if let image = cachedImage(url: url) {
            return Observable.just(image.imageData)
        }
        
        if let diskImage = cachedDiskImage(url: url) {
            cachingImage(url: url, cachable: diskImage)
            return callFetchPostImageWithEtag(path: path, cachable: diskImage)
        }
        
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
        
        let imageCount = cachable.imageData.count
        let requireDiskCount = imageCount + countCurrentDiskSize()
        
        if maxDiskLimit < requireDiskCount {
            deleteDiskImage(imageCount)
        }
        
        do {
            try cachable.imageData.write(to: fileURL)
            UserDefaultsManager.etag[fileURL.lastPathComponent] = cachable.eTag
        } catch {
            print("FILE SAVE ERROR")
        }
    }
    
    private func cachedDiskImage(url: URL) -> Cachable? {
        guard let fileURL = createFilePath(url: url) else { return nil }
        
        print(fileURL)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            guard let data = try? Data(contentsOf: fileURL) else { return nil }
            let cachable = Cachable(imageData: data, eTag: UserDefaultsManager.etag[fileURL.lastPathComponent])
            return cachable
        } else {
            return nil
        }
    }
    
    private func countCurrentDiskSize() -> Int {
        var count = 0
        
        do {
            let manager = FileManager.default
            let documentDirUrl = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            if manager.changeCurrentDirectoryPath(documentDirUrl.path) {
                for file in try manager.contentsOfDirectory(atPath: ".") {
                    let fileCount = try manager.attributesOfItem(atPath: file)[FileAttributeKey.size] as? Int ?? 0
                    count += fileCount
                }
            }
        }
        catch {
            print("COUNT CURRENT DISK SIZE ERROR: \(error)")
        }
        
        return count
    }
    
    private func deleteDiskImage(_ size: Int) {
        let maximumDays = 1.0
        let minimumDate = Date().addingTimeInterval(-maximumDays * 24 * 60 * 60)
        func meetsRequirement(date: Date) -> Bool { return date < minimumDate }
        
        do {
            let manager = FileManager.default
            let documentDirUrl = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            if manager.changeCurrentDirectoryPath(documentDirUrl.path) {
                for file in try manager.contentsOfDirectory(atPath: ".") {
                    let creationDate = try manager.attributesOfItem(atPath: file)[FileAttributeKey.creationDate] as? Date ?? Date()
                    if meetsRequirement(date: creationDate) {
                        try manager.removeItem(atPath: file)
                        UserDefaultsManager.etag.removeValue(forKey: file)
                    }
                }
                
                if maxDiskLimit < countCurrentDiskSize() + size {
                    for file in try manager.contentsOfDirectory(atPath: ".") {
                        if(maxDiskLimit > countCurrentDiskSize() + size) {
                            break
                        }
                        try manager.removeItem(atPath: file)
                        UserDefaultsManager.etag.removeValue(forKey: file)
                    }
                }
            }
        }
        catch {
            print("DELETE DISK IMAGE ERROR: \(error)")
        }
    }
    
    private func createFilePath(url: URL) -> URL? {
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        var fileURL = URL(fileURLWithPath: directoryPath)
        fileURL.appendPathComponent(url.lastPathComponent)
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
