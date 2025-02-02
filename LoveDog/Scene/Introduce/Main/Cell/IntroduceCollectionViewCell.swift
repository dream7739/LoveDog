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
    private let infoLabel = UILabel()
    private let seperatorLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.image = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubview(mainImage)
        contentView.addSubview(stateLabel)
        contentView.addSubview(noticeNoLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(seperatorLabel)
    }
    
    override func configureLayout() {
        mainImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(130)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImage)
            make.leading.equalTo(mainImage.snp.trailing).offset(10)
        }
        
        noticeNoLabel.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(4)
            make.leading.equalTo(stateLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(noticeNoLabel.snp.bottom).offset(4)
            make.leading.equalTo(stateLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        seperatorLabel.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    
    }
    
    override func configureView() {
        mainImage.contentMode = .scaleAspectFill
        mainImage.clipsToBounds = true
        mainImage.layer.cornerRadius = 10
        
        stateLabel.makeLightGrayRound()
        
        noticeNoLabel.font = Design.Font.quarternary_bold
        noticeNoLabel.numberOfLines = 2
        
        infoLabel.font = Design.Font.quarternary
        
        seperatorLabel.backgroundColor = .light_gray
    }
    
}

extension IntroduceCollectionViewCell {
    
    func configureData(data: FetchAbandonItem) {
        configureProfile(data.popfile)
        stateLabel.text = data.processState
        noticeNoLabel.text = data.noticeNo
        infoLabel.text = data.infoDescription
    }
    
    private func configureProfile(_ profileURL: String) {
        ImageCacheManager.shared.loadImage(urlString: profileURL)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.mainImage.setImage(data: value, size: owner.mainImage.bounds.size)
            }
            .disposed(by: disposeBag)
    }
    
}
