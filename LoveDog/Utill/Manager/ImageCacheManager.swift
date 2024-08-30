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
    
    private let cache = NSCache<NSString, UIImage>()
    
    func loadImage(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        if let image = cachedImage(url: url) {
            print("CACHE에 이미지 존재")
            return image
        }
        
        if let diskImage = cachedDiskImage(url: url) {
            print("DISK에 이미지 존재")
            return diskImage
        }
        
        return nil
    }
    
    func cachingImage(url: URL, image: UIImage) {
        let path = url.lastPathComponent
        cache.setObject(image, forKey: path as NSString)
    }
    
    func cachedImage(url: URL) -> UIImage? {
        let path = url.lastPathComponent
        return cache.object(forKey: path as NSString)
    }
    
    func cachedDiskImage(url: URL) -> UIImage? {
        
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        var fileURL = URL(fileURLWithPath: directoryPath)
        fileURL.appendPathComponent(url.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return nil
        }
    }
    
    func cachingDiskImage(url: URL, image: UIImage) {
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return
        }
        
        var fileURL = URL(fileURLWithPath: directoryPath)
        fileURL.appendPathComponent(url.lastPathComponent)

        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
    
        guard let _ = cachedDiskImage(url: url) else {
            do {
                try data.write(to: fileURL)
            } catch {
                print("FILE SAVE ERROR")
            }
            
            return
        }
    }
    
}
