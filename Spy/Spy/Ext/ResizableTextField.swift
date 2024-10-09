//
//  ResizableTextField.swift
//  Spy
//
//  Created by Вячеслав on 12/30/23.
//

import SwiftUI

struct ResizableTextView: UIViewRepresentable {
    
    @Binding var text: String
    
    @Binding var height: CGFloat
    @Binding var isFirstResponder: Bool
    @State var editing: Bool = false

    func makeUIView(context: Context) -> UITextView {
        
        let textView = UITextView()
        
        textView.isEditable = true
        textView.isScrollEnabled = true
        
        textView.delegate = context.coordinator
        textView.textColor = UIColor.white
        textView.backgroundColor = .clear
        
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        
        DispatchQueue.main.async {
            
            textView.text = self.text
            self.height = textView.contentSize.height
            
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
        
        var parent: ResizableTextView
        var didBecomeFirstResponder = false

        init(_ parent: ResizableTextView) {
            
            self.parent = parent
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            
            DispatchQueue.main.async {
                
                self.parent.editing = true
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            
            DispatchQueue.main.async {
                
                self.parent.editing = false
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            
            DispatchQueue.main.async {
                
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }

        func textView(_ textView: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            if let currentText = textView.text, let swiftRange = Range(range, in: currentText) {
                
                parent.text = currentText.replacingCharacters(in: swiftRange, with: string)
            }
            
            return true
        }

        func textViewShouldReturn(_ textView: UITextView) -> Bool {
            
            textView.resignFirstResponder()
            
            return true
        }
    }
}
