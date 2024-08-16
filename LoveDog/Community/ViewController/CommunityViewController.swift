//
//  CommunityViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommunityViewController: BaseViewController {
    private let writeButton = FloatingButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    let viewModel = CommunityViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        [collectionView, writeButton].forEach {
            view.addSubview($0)
        }
        
    }
    
    override func configureLayout() {
        writeButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        navigationItem.title = "스토리"
        collectionView.register(CommunityCollectionViewCell.self, forCellWithReuseIdentifier: CommunityCollectionViewCell.identifier)
    }
    
    private func bind() {
        let input = CommunityViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.postList
            .bind(to: collectionView.rx.items(cellIdentifier: CommunityCollectionViewCell.identifier, cellType: CommunityCollectionViewCell.self)){ row, element, cell in
                cell.configureData(element)
        }
        .disposed(by: disposeBag)
    }
    
}
