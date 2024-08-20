//
//  BasicTextView.swift
//  LoveDog
//
//  Created by 홍정민 on 8/17/24.
//

import UIKit
import PhotosUI

final class BasicTextView: UITextView {
    private var placeholderText: String!
    
    init(placeholder: String) {
        super.init(frame: .zero, textContainer: nil)
        placeholderText = placeholder
        delegate = self
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        font = Design.Font.secondary
        layer.cornerRadius = 10
        layer.borderColor = UIColor.main.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        contentInset = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        textColor = .placeholderText
        text = placeholderText
    }
}

extension BasicTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textColor == .placeholderText {
            text = ""
            textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let currentText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if currentText.isEmpty && textView.textColor == .black {
            text = placeholderText
            textColor = .placeholderText
        }
    }
}
