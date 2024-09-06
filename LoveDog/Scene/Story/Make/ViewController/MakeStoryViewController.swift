//
//  MakeStoryViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/16/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import SnapKit
import Toast

final class MakeStoryViewController: BaseViewController {
    private let cameraButton = UIButton()
    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let titleLabel = UILabel()
    private let titleTextField = BasicTextField()
    private let categoryLabel = UILabel()
    private let reviewButton = OptionButton(title: MakeCategory.review.rawValue)
    private let reportButton = OptionButton(title: MakeCategory.report.rawValue)
    private let dailyButton = OptionButton(title: MakeCategory.daily.rawValue)
    private let promotionButton = OptionButton(title: MakeCategory.promotion.rawValue)
    private let categoryStackView = UIStackView()
    private let contentLabel = UILabel()
    private let contentTextView = BasicTextView(placeholder: "내용을 입력해주세요")
    private lazy var categoryButtonList = [reviewButton, reportButton, dailyButton, promotionButton]
    private let emptyView = UIView()
    
    private let viewModel: MakeStoryViewModel
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
    
    init(viewModel: MakeStoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        [cameraButton, imageCollectionView, titleLabel, titleTextField,
         categoryLabel, categoryStackView, contentLabel, contentTextView, emptyView
        ].forEach {
            view.addSubview($0)
        }
        
        categoryButtonList.forEach {
            categoryStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        cameraButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(cameraButton)
            make.leading.equalTo(cameraButton.snp.trailing).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(75)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.bottom).offset(16)
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
            make.height.equalTo(38)
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
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    override func configureView() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = Design.Image.camera.applyingSymbolConfiguration(.init(pointSize: 15))
        configuration.cornerStyle = .medium
        configuration.background.strokeColor = .main
        configuration.baseForegroundColor = .dark_gray
        cameraButton.configuration = configuration
        
        imageCollectionView.register(StoryImageCollectionViewCell.self, forCellWithReuseIdentifier: StoryImageCollectionViewCell.identifier)
        imageCollectionView.alwaysBounceVertical = false
        
        titleLabel.text = "제목"
        titleLabel.font = Design.Font.tertiary_bold
        titleTextField.placeholder = "제목"
        titleTextField.font = Design.Font.secondary
        
        categoryLabel.text = "카테고리"
        categoryLabel.font = Design.Font.tertiary_bold
        categoryStackView.axis = .horizontal
        categoryStackView.spacing = 8
        categoryStackView.distribution = .fillEqually
        
        for (idx, button) in categoryButtonList.enumerated() {
            button.tag = idx
        }
        categoryButtonList[0].isClicked = true
        
        contentLabel.text = "내용"
        contentLabel.font = Design.Font.tertiary_bold
        contentTextView.font = Design.Font.secondary
    }
    
    override func configureNav(){
        super.configureNav()
        let close = UIBarButtonItem(image: Design.Image.close, style: .plain, target: self, action: nil)
        let save = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = close
        navigationItem.rightBarButtonItem = save
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension MakeStoryViewController {
    private func bind() {
        let input = MakeStoryViewModel.Input(
            saveTap: navigationItem.rightBarButtonItem!.rx.tap,
            title: titleTextField.rx.text.orEmpty,
            content: contentTextView.rx.text.orEmpty,
            category: BehaviorRelay(value: MakeCategory.review.rawValue)
        )
        
        let output = viewModel.transform(input: input)
        
        output.uploadSuccess
            .bind(with: self) { owner, value in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.uploadError
            .bind(with: self) { owner, value in
                owner.view.makeToast(value)
            }
            .disposed(by: disposeBag)
        
        output.modifyStory
            .compactMap { $0 }
            .bind(with: self) { owner, value in
                owner.createImages(value.files)
                
                owner.titleTextField.text = value.title
                owner.titleTextField.sendActions(for: .valueChanged)
                
                if let content = value.content {
                    owner.contentTextView.text = content
                    owner.contentTextView.textColor = .black
                }
                
                let category = MakeCategory(rawValue: value.content1) ?? .daily
                let index = category.index
                owner.categoryButtonList[index].isClicked = true
                owner.deselectOptionButtons(index)
                input.category.accept(category.rawValue)
            }
            .disposed(by: disposeBag)
        
        output.navigationTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, value in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.openGallery()
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedImages
            .bind(to: imageCollectionView.rx.items(cellIdentifier: StoryImageCollectionViewCell.identifier, cellType: StoryImageCollectionViewCell.self)){
                row, element, cell in
                
                cell.configureImage(element)
                
                cell.deleteButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.viewModel.imageList.remove(at: row)
                        owner.viewModel.fileList.remove(at: row)
                        owner.viewModel.selectedImages.accept(owner.viewModel.imageList)
                        owner.viewModel.fileNames.accept(owner.viewModel.fileList)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        categoryButtonList.forEach { button in
            button.rx.tap
                .bind(with: self) { owner, value in
                    button.isClicked = true
                    input.category.accept(MakeCategory.allCases[button.tag].rawValue)
                    owner.deselectOptionButtons(button.tag)
                }
                .disposed(by: disposeBag)
        }
    }
}

extension MakeStoryViewController {
    private enum MakeCategory: String, CaseIterable {
        case review = "입양후기"
        case report = "신고/제보"
        case daily = "일상"
        case promotion = "입양홍보"
        
        var index: Int {
            switch self {
            case .review:
                return 0
            case .report:
                return 1
            case .daily:
                return 2
            case .promotion:
                return 3
            }
        }
    }
    
    private func deselectOptionButtons(_ selectedIndex: Int) {
        for (idx, button) in categoryButtonList.enumerated() {
            if idx == selectedIndex { continue }
            button.isClicked = false
        }
    }
    
    private func createImages(_ files: [String]) {
        var imageList: [UIImage] = []
        var fileList: [String] = []
        
        for (idx, path) in files.enumerated() {
            ImageCacheManager.shared.loadImage(urlString: path)
                .bind(with: self) { owner, value in
                    if let image = UIImage(data: value) {
                        imageList.append(image)
                        fileList.append("image_\(idx)")
                        owner.viewModel.imageList = imageList
                        owner.viewModel.fileList = fileList
                        owner.viewModel.selectedImages.accept(imageList)
                        owner.viewModel.fileNames.accept(fileList)
                    }
                }
                .disposed(by: disposeBag)
        }
    }
  
}

extension MakeStoryViewController: PHPickerViewControllerDelegate {
    
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        if results.isEmpty {
            return
        }
        
        var imageList: [UIImage] = []
        var fileList: [String] = []
        
        let group = DispatchGroup()
        
        for (_, result) in results.enumerated() {
            DispatchQueue.global().async(group: group) {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            imageList.append(image)
                            fileList.append(result.itemProvider.suggestedName ?? "")
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.viewModel.imageList = imageList
            self?.viewModel.fileList = fileList
            self?.viewModel.selectedImages.accept(imageList)
            self?.viewModel.fileNames.accept(fileList)
        }
    }
}
