//
//  TextView.swift
//  Gif Maker
//
//  Created by Andrew Nguyen on 7/19/20.
//  Copyright © 2020 six. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var textOverlay: TextOverlay
    @Binding var text: String
    var font: UIFont
    var color: UIColor
    var fontSize: CGFloat
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = self.font.withSize(self.fontSize)
        textView.textColor = self.color
        textView.text = self.text
        
        textView.returnKeyType = .done
        textView.backgroundColor = .none
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
//        self.text = uiView.text
//        uiView.font = .systemFont(ofSize: self.fontSize)
        uiView.font = self.font.withSize(self.fontSize)
        uiView.textColor = self.color
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(_ parent: TextView) {
            self.parent = parent
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                self.parent.textOverlay.text = textView.text
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
}
