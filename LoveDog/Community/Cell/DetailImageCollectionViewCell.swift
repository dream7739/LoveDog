//
//  DetailImageCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import UIKit

final class DetailImageCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func configureHierarchy() {
        [imageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    }
    
    func configureImage(_ image: String){
        imageView.image = UIImage(resource: .dogSample1)
    }
}
