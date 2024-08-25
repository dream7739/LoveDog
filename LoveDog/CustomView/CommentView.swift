//
//  CommentView.swift
//  LoveDog
//
//  Created by 홍정민 on 8/25/24.
//

import UIKit
import SnapKit

final class CommentView: BaseView {
    let seperatorLabel = UILabel()
    let backgroundView = UIView()
    let inputTextView = UITextView()
    let sendButton = UIButton()
    
    override func configureHierarchy() {
        addSubview(seperatorLabel)
        addSubview(backgroundView)
        backgroundView.addSubview(inputTextView)
        backgroundView.addSubview(sendButton)
    }
    
    override func configureLayout() {
        seperatorLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        inputTextView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(backgroundView).inset(8)
            make.leading.equalTo(backgroundView).inset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.height.equalTo(24)
        }
        
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(inputTextView)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(30)
        }
        
    }
    
    override func configureView() {
        backgroundColor = .white
        seperatorLabel.backgroundColor = .light_gray
        inputTextView.backgroundColor = .light_gray
        inputTextView.layer.cornerRadius = 10
        inputTextView.contentInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        inputTextView.tintColor = .main
        
        sendButton.configuration = ButtonConfiguration.basic
        var container = AttributeContainer()
        container.font = Design.Font.tertiary_bold
        sendButton.configuration?.attributedTitle = AttributedString("전송", attributes: container)
    }
}
