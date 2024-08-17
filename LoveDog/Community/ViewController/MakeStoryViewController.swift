//
//  MakeStoryViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


//사진 - 사진 collection - 제목 - 카테고리 - 콘텐츠
//카테고리: 입양후기, 실종/제보, 일상, 입양홍보

final class MakeStoryViewController: BaseViewController {
    private let cameraButton = UIButton()
    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let titleLabel = UILabel()
    private let titleTextField = BasicTextField()
    private let categoryLabel = UILabel()
    private let categoryStackView = UIStackView()
    private let contentLabel = UILabel()
    private let contentTextView = BasicTextView(placeholder: "내용을 입력해주세요")
    
    private let disposeBag = DisposeBag()
    
    private func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(75), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(407), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        bind()
    }
    
    override func configureHierarchy() {
        [cameraButton, imageCollectionView, titleLabel, titleTextField,
         categoryLabel, categoryStackView, contentLabel, contentTextView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        cameraButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(75)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.height.equalTo(200)
            make.horizontalEdges.equalTo(titleLabel)
        }
    }
    
    override func configureView() {
  
        cameraButton.configuration = ButtonConfiguration.camera
        
        imageCollectionView.register(StoryImageCollectionViewCell.self, forCellWithReuseIdentifier: StoryImageCollectionViewCell.identifier)
        imageCollectionView.alwaysBounceVertical = false
        
        titleLabel.text = "제목"
        titleLabel.font = Design.Font.tertiary_bold
        titleTextField.placeholder = "제목"
        titleTextField.font = Design.Font.secondary
        
        categoryLabel.text = "카테고리"
        categoryLabel.font = Design.Font.tertiary_bold
        categoryStackView.axis = .horizontal
        categoryStackView.backgroundColor = .main
        
        contentLabel.text = "내용"
        contentLabel.font = Design.Font.tertiary_bold
        contentTextView.font = Design.Font.secondary
        
        
    }
    
    private func configureNav(){
        navigationItem.title = "스토리 작성"
        let close = UIBarButtonItem(image: Design.Image.close, style: .plain, target: self, action: nil)
        let save = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = close
        navigationItem.rightBarButtonItem = save
    }
    
    private func bind(){
        navigationItem.leftBarButtonItem?
            .rx
            .tap
            .bind(with: self) { owner, value in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        Observable.just(["a", "b", "c", "d", "e"])
            .bind(to: imageCollectionView.rx.items(cellIdentifier: StoryImageCollectionViewCell.identifier, cellType: StoryImageCollectionViewCell.self)){
               collectionView, row, element in
                     
            }
            .disposed(by: disposeBag)
    }
}
