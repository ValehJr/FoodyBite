//
//  PaddedTextView.swift
//  FoodyBite
//
//  Created by Valeh Ismayilov on 31.10.23.
//

import UIKit

class PaddedTextView: UITextView {
    
    private let dynamicPadding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let placeholderText = "Write your Experience"
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        setupTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextView()
    }
    
    private func setupTextView() {
        textContainerInset = dynamicPadding
        text = placeholderText
        textColor = .lightGray
        delegate = self
    }
}

extension PaddedTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}
