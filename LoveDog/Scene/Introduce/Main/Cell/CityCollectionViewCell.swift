//
//  CityCollectionViewCell.swift
//  LoveDog
//
//  Created by 홍정민 on 9/1/24.
//

import UIKit
import SnapKit
import RxSwift

final class CityCollectionViewCell: BaseCollectionViewCell {
    private let cityLabel = PaddingLabel()

    var isClicked: Bool = false {
        didSet {
            if isClicked {
                cityLabel.makeBlueBackground()
            } else {
                cityLabel.makeLightGrayRound()
            }
        }
    }
    
    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.makeLightGrayRound()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(cityLabel)
    }
    
    override func configureLayout() {
        cityLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureData(data: String) {
        cityLabel.text = data
        cityLabel.makeLightGrayRound()
    }
    
}
