//
//  DetailCommentCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailCommentCollectionViewCell: BaseCollectionViewCell {
    private let profileImage = ProfileImageView()
    private let nicknameLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()
    
    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [profileImage, nicknameLabel, dateLabel, contentLabel]
            .forEach {
                contentView.addSubview($0)
            }
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.size.equalTo(32)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.leading.equalTo(nicknameLabel)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
    }
    
    func configureData(_ data: Comment) {
        if let path = data.creator.profileImage {
            let urlString = APIURL.sesacBaseURL + "/\(path)"
            
            ImageCacheManager.shared.loadImage(urlString: urlString, path: path)
                .observe(on: MainScheduler.instance)
                .subscribe(with: self) { owner, value in
                    owner.profileImage.setImage(data: value, size: owner.profileImage.bounds.size)
                } onError: { owner, error in
                    print("LOAD IMAGE ERROR \(error)")
                }
                .disposed(by: disposeBag)
        } else {
            profileImage.image = UIImage(resource: .profileEmpty)
        }
        
        nicknameLabel.text = data.creator.nick
        nicknameLabel.font = Design.Font.tertiary
        
        dateLabel.text = data.dateDescription
        dateLabel.font = Design.Font.quarternary
        dateLabel.textColor = .dark_gray
        
        contentLabel.text = data.content
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byCharWrapping
        contentLabel.font = Design.Font.tertiary
        
    }
}
