//
//  IntroduceViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class IntroduceViewController: BaseViewController {

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(230))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(230))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    let viewModel = IntroduceViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "소개"
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        collectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
    }
}

extension IntroduceViewController {
    private func bind() {
        let input = IntroduceViewModel.Input(
            request: BehaviorRelay(value: FetchAbandonRequest(pageNo: 1))
        )
        let output = viewModel.transform(input: input)
        
        output.abondonList
            .debug("abondonList")
            .bind(to: collectionView.rx.items(cellIdentifier: BaseCollectionViewCell.identifier, cellType: BaseCollectionViewCell.self)){
                (row, element, cell) in
                cell.backgroundColor = .magenta
            }
            .disposed(by: disposeBag)
    }
}
