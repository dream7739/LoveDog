//
//  CommunityCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import UIKit
import SnapKit
import RxSwift

//이미지
//타이틀
//생성일
//좋아요 댓글 수
final class CommunityCollectionViewCell: BaseCollectionViewCell {
    private let baseView = UIView()
    private let mainImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let categoryLabel = PaddingLabel()
    private let iconStackView = UIStackView()
    private let likeImage = UIImageView()
    private let likeCountLabel = UILabel()
    private let commentImage = UIImageView()
    private let commentCountLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        contentView.addSubview(baseView)
        
        [mainImageView, titleLabel, dateLabel, categoryLabel, iconStackView]
            .forEach {
                baseView.addSubview($0)
            }
        
        [likeImage, likeCountLabel, commentImage, commentCountLabel]
            .forEach {
                iconStackView.addArrangedSubview($0)
            }
    }
    
    override func configureLayout() {
        baseView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(baseView)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(baseView).inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
            make.leading.equalTo(baseView).offset(18)
        }
        
        iconStackView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel)
            make.leading.greaterThanOrEqualTo(baseView.snp.leading).offset(20)
            make.trailing.equalTo(baseView.snp.trailing).offset(-20)
            make.height.equalTo(18)
        }
        
        likeImage.snp.makeConstraints { make in
            make.width.equalTo(16)
        }
        
        commentImage.snp.makeConstraints { make in
            make.width.equalTo(17)
        }
        
    }
    
    override func configureView() {
        baseView.layer.cornerRadius = 10
        baseView.layer.borderColor = UIColor.main.cgColor
        baseView.layer.borderWidth = 1
        baseView.clipsToBounds = true
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        
        titleLabel.font = Design.Font.secondary
        
        dateLabel.font = Design.Font.tertiary
        dateLabel.textColor = .dark_gray
        
        categoryLabel.backgroundColor = .light_gray
        categoryLabel.layer.cornerRadius = 8
        categoryLabel.clipsToBounds = true
        categoryLabel.font = Design.Font.quarternary
        
        iconStackView.axis = .horizontal
        iconStackView.spacing = 2
        
        likeImage.image = Design.Image.like
        likeImage.tintColor = .dark_gray
        
        likeCountLabel.font = Design.Font.quarternary
        likeCountLabel.textColor = .dark_gray
        
        commentImage.image = Design.Image.comment
        commentImage.tintColor = .dark_gray
        
        commentCountLabel.font = Design.Font.quarternary
        commentCountLabel.textColor = .dark_gray
        
    }
    
    func configureData(_ data: Post){
        configureMainImage(path: data.files[0])
        titleLabel.text = data.title
        dateLabel.text = data.dateDescription
        categoryLabel.text = data.content1
        likeCountLabel.text = data.likes.count.formatted()
        commentCountLabel.text = data.comments.count.formatted()
    }
    
    private func configureMainImage(path: String) {
        PostManager.shared.fetchPostImage(path: path)
            .subscribe(with: self){ owner, result in
                switch result {
                case .success(let value):
                    owner.mainImageView.image = value
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
        
    }
    
}
