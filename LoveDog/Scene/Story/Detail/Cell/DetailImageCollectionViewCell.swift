//
//  DetailImageCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import UIKit
import RxSwift

final class DetailImageCollectionViewCell: BaseCollectionViewCell {
    
    private let mainImageView = UIImageView()
    private let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
    
    override func configureHierarchy() {
        [mainImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        
    }
    
    func configureImage(_ imagePath: String){
        let urlString = APIURL.sesacBaseURL + "/\(imagePath)"
        
        if let image = ImageCacheManager.shared.loadImage(urlString: urlString) {
            mainImageView.image = image
        }else {
            callFetchPostImage(imagePath)
        }
    }
    
    private func callFetchPostImage(_ path: String) {
        PostManager.shared.fetchPostImage(path: path)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.mainImageView.image = value
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
