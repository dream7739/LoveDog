//
//  StoryViewModel.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import UIKit
import ImageIO
import SnapKit
import RxSwift

final class StoryCollectionViewCell: BaseCollectionViewCell {
    private let baseView = UIView()
    private let entireStackView = UIStackView()
    private let subStackView1 = UIStackView()
    private let subStackView2 = UIStackView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let categoryLabel = PaddingLabel()
    private let iconStackView = UIStackView()
    private let likeCountLabel = UILabel()
    private let commentCountLabel = UILabel()
    private let seperatorLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subStackView1.subviews.forEach { $0.removeFromSuperview() }
        subStackView2.subviews.forEach { $0.removeFromSuperview() }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(baseView)
        
        [entireStackView, titleLabel, dateLabel, categoryLabel, iconStackView, seperatorLabel]
            .forEach {
                baseView.addSubview($0)
            }
        
        [likeCountLabel, commentCountLabel]
            .forEach {
                iconStackView.addArrangedSubview($0)
            }
        
        [subStackView1, subStackView2]
            .forEach {
                entireStackView.addArrangedSubview($0)
            }
    }
    
    override func configureLayout() {
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(baseView.snp.top).offset(10)
            make.leading.equalTo(baseView).offset(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(baseView).inset(15)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        entireStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(baseView)
            make.height.equalTo(360)
        }
        
        iconStackView.snp.makeConstraints { make in
            make.top.equalTo(entireStackView.snp.bottom).offset(6)
            make.leading.greaterThanOrEqualTo(baseView.snp.leading).offset(15)
            make.trailing.equalTo(baseView.snp.trailing).offset(-15)
        }
        
        seperatorLabel.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.horizontalEdges.equalTo(baseView)
        }
    }
    
    override func configureView() {
        entireStackView.axis = .vertical
        entireStackView.spacing = 4
        
        subStackView1.spacing = 4
        subStackView2.spacing = 4

        subStackView1.axis = .horizontal
        subStackView1.distribution = .fillEqually
        
        subStackView2.axis = .horizontal
        subStackView2.distribution = .fillEqually
        
        titleLabel.font = Design.Font.tertiary
        
        dateLabel.font = Design.Font.mini
        dateLabel.textColor = .deep_gray
        
        categoryLabel.makeLightGrayRound()
        
        iconStackView.axis = .horizontal
        iconStackView.spacing = 6
        
        likeCountLabel.font = Design.Font.mini
        likeCountLabel.textColor = .deep_gray
        
        commentCountLabel.font = Design.Font.mini
        commentCountLabel.textColor = .deep_gray
        
        seperatorLabel.backgroundColor = .light_gray
    }
    
    func configureData(_ data: Post){
        configureMainImage(path: data.files)
        titleLabel.text = data.title
        dateLabel.text = data.dateDescription
        categoryLabel.text = data.content1
        likeCountLabel.text = data.likeDescription
        commentCountLabel.text = data.commentDescription
    }
    
    private func configureMainImage(path: [String]) {
        switch path.count {
        case 1:
            entireStackView.distribution = .fill
            let imageView1 = UIImageView()
            subStackView1.addArrangedSubview(imageView1)
            loadImage(imageView: imageView1, path: path[0])
        case 2:
            entireStackView.distribution = .fill
            for idx in 0..<path.count {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                subStackView1.addArrangedSubview(imageView)
                loadImage(imageView: imageView, path: path[idx])
            }
        case 3, 4, 5:
            entireStackView.distribution = .fillEqually
            for idx in 0..<path.count {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                if idx < 2 {
                    subStackView1.addArrangedSubview(imageView)
                } else {
                    subStackView2.addArrangedSubview(imageView)
                }
                loadImage(imageView: imageView, path: path[idx])
            }
        default:
            print("DEFAULT")
        }
    }
    
    private func loadImage(imageView: UIImageView, path: String) {
        let urlString = APIURL.sesacBaseURL + "/\(path)"
        
        ImageCacheManager.shared.loadImage(urlString: urlString, path: path)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                imageView.setImage(data: value, size: imageView.bounds.size)
            } onError: { owner, error in
                print("LOAD IMAGE ERROR \(error)")
            }
            .disposed(by: disposeBag)
    }
    
}
