//
//  IntroduceCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift

final class IntroduceCollectionViewCell: BaseCollectionViewCell {
    private let mainImage = UIImageView()
    private let stateLabel = PaddingLabel()
    private let noticeNoLabel = UILabel()
    private let footImage = UIImageView()
    private let infoLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.image = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubview(mainImage)
        contentView.addSubview(stateLabel)
        contentView.addSubview(footImage)
        contentView.addSubview(noticeNoLabel)
        contentView.addSubview(infoLabel)
    }
    
    override func configureLayout() {
        mainImage.snp.makeConstraints { make in
            make.height.equalTo(190)
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(6)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        noticeNoLabel.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(4)
            make.leading.equalTo(stateLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-10)
        }
        
        footImage.snp.makeConstraints { make in
            make.top.equalTo(noticeNoLabel.snp.bottom).offset(4)
            make.width.equalTo(15)
            make.height.equalTo(12)
            make.leading.equalTo(stateLabel)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(footImage.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-10)
            make.centerY.equalTo(footImage)
        }
        
    }
    
    override func configureView() {
        mainImage.contentMode = .scaleAspectFill
        mainImage.clipsToBounds = true
        
        stateLabel.makeLightGrayRound()
        
        noticeNoLabel.font = Design.Font.quarternary_bold
        noticeNoLabel.numberOfLines = 2
        
        footImage.image = UIImage(resource: .foot).withTintColor(.main)
        
        infoLabel.font = Design.Font.quarternary
    }
    
   
}

extension IntroduceCollectionViewCell {
    
    func configureData(data: FetchAbandonItem) {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.layer.borderColor = UIColor.main.cgColor
        contentView.layer.borderWidth = 1
        
        configureProfile(data.popfile)
        stateLabel.text = data.processState
        noticeNoLabel.text = data.noticeNo
        footImage.image = UIImage(resource: .foot)
        infoLabel.text = data.infoDescription
    }
    
    private func configureProfile(_ profileURL: String) {
        if let image = ImageCacheManager.shared.loadImage(urlString: profileURL) {
            mainImage.image = image
        } else {
            callFetchProfileImage(profileURL)
        }
    }
    
    private func callFetchProfileImage(_ urlString: String) {
        
        OpenAPIManager.shared.fetchAbondonPublicImage(urlString)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.mainImage.image = value
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}
