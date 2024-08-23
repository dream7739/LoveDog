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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(270))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(270))
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
        collectionView.register(IntroduceCollectionViewCell.self, forCellWithReuseIdentifier: IntroduceCollectionViewCell.identifier)
    }
}

extension IntroduceViewController {
    private func bind() {
        let input = IntroduceViewModel.Input(
            request: BehaviorRelay(value: FetchAbandonRequest(pageNo: 1)),
            prefetch: PublishRelay<Void>()
        )
        let output = viewModel.transform(input: input)
        
        output.abondonList
            .bind(to: collectionView.rx.items(cellIdentifier: IntroduceCollectionViewCell.identifier, cellType: IntroduceCollectionViewCell.self)){
                (row, element, cell) in
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems
            .bind(with: self) { owner, value in
                let itemList = owner.viewModel.abandonResponse.items.item
                print(itemList.count, value)
                value.forEach { idx in
                    if idx.item == itemList.count - 4 {
                        input.prefetch.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
