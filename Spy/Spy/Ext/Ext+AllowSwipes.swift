//
//  Ext+AllowSwipes.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI

extension UINavigationController: UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return viewControllers.count > 1
    }
}
