//
//  Ext+RespondedTextField.swift
//  Spy
//
//  Created by Вячеслав on 11/13/23.
//

import SwiftUI

struct RespondedTextField: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    var onCommit: () -> Void
    
    func makeUIView(context: Context) -> UITextView {
        
        let textView = UITextView()
        
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.delegate = context.coordinator
        textView.textColor = UIColor.white
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.returnKeyType = .done
        textView.enablesReturnKeyAutomatically = true
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        
        DispatchQueue.main.async {
            
            textView.text = self.text
            
            if self.isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
                
                textView.becomeFirstResponder()
                context.coordinator.didBecomeFirstResponder = true
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: RespondedTextField
        var didBecomeFirstResponder = false
        
        init(_ parent: RespondedTextField) {
            
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            let currentText = textView.text ?? ""
            
            if currentText.contains("\n") {
                
                let newText = currentText.replacingOccurrences(of: "\n", with: "")
                textView.text = newText
                
                DispatchQueue.main.async {
                    
                    self.parent.text = newText
                    
                    textView.resignFirstResponder()
                     
                    self.parent.onCommit()
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    self.parent.text = currentText
                }
            }
        }
    }
}
