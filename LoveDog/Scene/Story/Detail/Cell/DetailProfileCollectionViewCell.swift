//
//  DetailProfileCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 8/21/24.
//

import UIKit
import SnapKit
import RxSwift

final class DetailProfileCollectionViewCell: BaseCollectionViewCell {
    
    let profileView = FeedProfileView()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [profileView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureData(_ data: Creator, _ isFollowed: Bool) {
        //작성자 프로필 - 이미지
        if let path = data.profileImage {
            let urlString = APIURL.sesacBaseURL + "/\(path)"
            
            ImageCacheManager.shared.loadImage(urlString: urlString, path: path)
                .observe(on: MainScheduler.instance)
                .subscribe(with: self) { owner, value in
                    owner.profileView.profileImage.setImage(data: value, size: owner.profileView.bounds.size)
                } onError: { owner, error in
                    print("LOAD IMAGE ERROR \(error)")
                }
                .disposed(by: disposeBag)
        }
        
        //작성자 프로필 - 닉네임
        profileView.nicknameLabel.text = data.nick
    
        /* 작성자가 유저 본인일 경우
         - 팔로잉 버튼 숨기기, 수정&삭제 버튼 표시
         * 작성자가 다른 사람일 경우
         - 팔로잉 버튼 표시, 수정&삭제 버튼 숨기기
         */
        if UserDefaultsManager.userId == data.user_id {
            profileView.followButton.isHidden = true
            profileView.editButton.isHidden = false
        } else {
            profileView.followButton.isHidden = false
            profileView.editButton.isHidden = true
        }
        
        /*
         이미 팔로우된 경우
         - "팔로잉 취소" 출력
         팔로우가 아닌 경우
         - "팔로잉"
         */
        
        var container = AttributeContainer()
        container.font = Design.Font.secondary_bold
        if isFollowed {
            profileView.followButton.configuration?.attributedTitle = AttributedString("언팔로우", attributes: container)
        } else {
            profileView.followButton.configuration?.attributedTitle = AttributedString("팔로우", attributes: container)
        }
        
    }
    
}
