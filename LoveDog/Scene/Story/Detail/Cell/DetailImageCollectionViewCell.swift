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
    
    func configureImage(_ path: String){
        let urlString = APIURL.sesacBaseURL + "/\(path)"
        
        ImageCacheManager.shared.loadImage(urlString: urlString, path: path)
            .subscribe(with: self) { owner, value in
                owner.mainImageView.image = UIImage(data: value)
            } onError: { owner, error in
                print("LOAD IMAGE ERROR \(error)")
            }
            .disposed(by: disposeBag)
        
    }
    
}
