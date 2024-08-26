//
//  StoryImageCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/17/24.
//

import UIKit
import SnapKit
import RxSwift

final class StoryImageCollectionViewCell: BaseCollectionViewCell {
    
    private let mainImageView = UIImageView()
    let deleteButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [mainImageView, deleteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(70)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(20)
        }
    }
    
    override func configureView() {
        mainImageView.backgroundColor = .main
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.layer.cornerRadius = 10
        mainImageView.clipsToBounds = true
        
        deleteButton.configuration = ButtonConfiguration.delete
    }
    
    func configureImage(_ image: UIImage){
        mainImageView.image = image
    }
    
}
