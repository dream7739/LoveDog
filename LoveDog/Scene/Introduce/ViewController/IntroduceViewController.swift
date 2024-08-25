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
    
    private let toolBar = UIToolbar()
    private let pickerView = UIPickerView()
    private let cityTextField = UITextField()
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
        [collectionView, cityTextField].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        cityTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        

    }
    
    override func configureView() {
        //툴바
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        toolBar.setItems([flexibleSpace, done], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //텍스트필드
        cityTextField.inputView = pickerView
        cityTextField.inputAccessoryView = toolBar
        cityTextField.delegate = self
        cityTextField.text = "서울특별시"
        cityTextField.font = Design.Font.primary
        cityTextField.tintColor = .clear

        let iconImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iconImage.image = UIImage(systemName: "chevron.down")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        
        cityTextField.rightView = iconImage
        cityTextField.rightViewMode = .always
        
        //컬렉션뷰
        collectionView.register(IntroduceCollectionViewCell.self, forCellWithReuseIdentifier: IntroduceCollectionViewCell.identifier)

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
            .bind(to: pickerView.rx.itemTitles){ row, item in
                return "\(item.orgdownNm)"
             }
            .disposed(by: disposeBag)
                
        toolBar.items?.last?
            .rx.tap
            .withLatestFrom(pickerView.rx.modelSelected(SidoModel.self))
            .compactMap { $0.first }
            .debug("TOOLBAR")
            .bind(with: self) { owner, value in
                owner.cityTextField.text = value.orgdownNm
                owner.cityTextField.endEditing(true)
                input.request.accept(FetchAbandonRequest(upperCd: Int(value.orgCd) ?? 0, pageNo: 1))
            }
            .disposed(by: disposeBag)
        
        output.abondonList
            .bind(to: collectionView.rx.items(cellIdentifier: IntroduceCollectionViewCell.identifier, cellType: IntroduceCollectionViewCell.self)){
                (row, element, cell) in
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        output.scrollToTop
            .bind(with: self) { owner, _ in
                owner.collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .top, animated: true)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems
            .bind(with: self) { owner, value in
                let itemList = owner.viewModel.abandonResponse.items.item
                value.forEach { idx in
                    if idx.item == itemList.count - 4 {
                        input.prefetch.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

extension IntroduceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

