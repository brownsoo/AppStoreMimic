//
//  UIViewPreview.swift
//  KabangExam
//
//  Created by hyonsoo on 2023/09/18.
//

import SwiftUI

struct UIViewPreview<V: UIView>: UIViewRepresentable {
    let builder: () -> V
    init(_ builder: @escaping () -> V) {
        self.builder = builder
    }
    
    func makeUIView(context: Context) -> some UIView {
        return builder()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
