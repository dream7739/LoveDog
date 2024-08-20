//
//  StoryDetailViewController.swift
//  LoveDog
//
//  Created by 홍정민 on 8/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class StoryDetailViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let profileView = FeedProfileView()
    
    private let viewModel: StoryDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: StoryDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "스토리 상세"
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.verticalEdges.equalTo(scrollView)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(55)
        }
        
    }
    
    override func configureView() {
        profileView.backgroundColor = .blue
    }
}

extension StoryDetailViewController {
    private func bind() {
        let input = StoryDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
    
        output.postDetail
            .bind(with: self) { owner, post in
                print("응답으로 받은 post", post)
            }
            .disposed(by: disposeBag)
    }
}
