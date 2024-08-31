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
        if let path = data.files.first {
            let urlString = APIURL.sesacBaseURL + "/\(path)"
            
            ImageCacheManager.shared.loadImage(urlString: urlString, path: path)
                .subscribe(with: self) { owner, value in
                    owner.photoImage.image = UIImage(data: value)
                } onError: { owner, error in
                    print("LOAD IMAGE ERROR \(error)")
                }
                .disposed(by: disposeBag)
        }
    }
    
}
