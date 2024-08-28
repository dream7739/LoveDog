//
//  ProfilePostCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfilePostCollectionViewCell: BaseCollectionViewCell {
    let photoImage = UIImageView()
    
    var disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        contentView.addSubview(photoImage)
    }
    
    override func configureLayout() {
        photoImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureView() {
        photoImage.contentMode = .scaleAspectFill
        photoImage.clipsToBounds = true
    }
    
    func configureData(_ data: Post) {
        if let imagePath = data.files.first {
            let urlString = APIURL.sesacBaseURL + "/\(imagePath)"
            
            if let image = ImageCacheManager.shared.loadImage(urlString: urlString) {
                photoImage.image = image
            } else {
                callFetchPostImage(imagePath)
            }
        }
    }
    
    private func callFetchPostImage(_ path: String) {
        PostManager.shared.fetchPostImage(path: path)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.photoImage.image = value
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
