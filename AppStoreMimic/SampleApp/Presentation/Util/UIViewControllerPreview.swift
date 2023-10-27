//
//  UIViewControllerPreview.swift
//  AppStoreMimic
//
//  Created by hyonsoo han on 2023/09/19.
//

import SwiftUI

struct UIViewControllerPreview<U: UIViewController>: UIViewControllerRepresentable {
    
    let builder: () -> U
    
    init(_ builder: @escaping () -> U) {
        self.builder = builder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return builder()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    
}
