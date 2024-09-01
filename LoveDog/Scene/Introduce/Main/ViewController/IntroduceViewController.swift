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
    
    private lazy var sidoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: cityLayout())
    private lazy var animalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private func cityLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1280), heightDimension: .absolute(27))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 15, bottom: 4, trailing: 15)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private var selectedIndex = IndexPath(item: 0, section: 0)
    let viewModel = IntroduceViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constant.Navigation.introduce
        bind()
    }
    
    override func configureHierarchy() {
        [sidoCollectionView, animalCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        sidoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(35)
        }
        
        animalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sidoCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        sidoCollectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        animalCollectionView.register(IntroduceCollectionViewCell.self, forCellWithReuseIdentifier: IntroduceCollectionViewCell.identifier)
    }
    
}


extension IntroduceViewController {
    private func bind() {
        let input = IntroduceViewModel.Input(
            jsonParse: BehaviorRelay(value: "SidoCode"),
            request: BehaviorRelay(value: FetchAbandonRequest(upperCd: 6110000, pageNo: 1)),
            prefetch: PublishRelay<Void>()
        )
        
        let output = viewModel.transform(input: input)
        
        output.sidoList
            .bind(to: sidoCollectionView.rx.items(cellIdentifier: CityCollectionViewCell.identifier, cellType: CityCollectionViewCell.self)){ [weak self] (row, element, cell) in
                cell.configureData(data: element.orgdownNm)
                if row == self?.selectedIndex.item {
                    cell.isClicked = true
                } else {
                    cell.isClicked = false
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(sidoCollectionView.rx.itemSelected,
            sidoCollectionView.rx.modelSelected(SidoModel.self))
            .withUnretained(self)
            .filter { value in self.selectedIndex != value.1.0 }
            .map { value in return value.1 }
            .bind(with: self) { owner, value in
                owner.selectedIndex = value.0
                output.sidoList.accept(output.sidoList.value)
                input.request.accept(FetchAbandonRequest(upperCd: Int(value.1.orgCd) ?? 0, pageNo: 1))
            }
            .disposed(by: disposeBag)
        
        output.abondonList
            .bind(to: animalCollectionView.rx.items(cellIdentifier: IntroduceCollectionViewCell.identifier, cellType: IntroduceCollectionViewCell.self)){
                (row, element, cell) in
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        output.scrollToTop
            .bind(with: self) { owner, _ in
                owner.animalCollectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .top, animated: true)
            }
            .disposed(by: disposeBag)
        
        animalCollectionView.rx.prefetchItems
            .bind(with: self) { owner, value in
                let itemList = owner.viewModel.abandonResponse.items.item
                value.forEach { idx in
                    if idx.item == itemList.count - 4 {
                        input.prefetch.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        animalCollectionView.rx.modelSelected(FetchAbandonItem.self)
            .bind(with: self) { owner, value in
                let detailVC = IntroduceDetailViewController()
                detailVC.viewModel.fetchAbandonItem.accept(value)
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension IntroduceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

