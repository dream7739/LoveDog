//
//  UIImageView+.swift
//  LoveDog
//
//  Created by 홍정민 on 9/1/24.
//

import UIKit

extension UIImageView {
    func setImage(data: Data, size: CGSize) {
        
        //다운샘플링 옵션
        let options: [NSString: Any] = [
                  kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height) * UIScreen.main.scale,
                  kCGImageSourceCreateThumbnailFromImageAlways: true,
                  kCGImageSourceShouldCacheImmediately: true
              ]
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
        let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else { return }
        let resizedImage = UIImage(cgImage: cgImage)
        self.image = resizedImage
    }
}
