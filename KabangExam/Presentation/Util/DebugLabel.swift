//
//  DebugLabel.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/20.
//


import UIKit

protocol DebugLabel {
    func showDebugLabel(_ text: String)
}

extension UIView: DebugLabel {
    func showDebugLabel(_ text: String) {
        let tg = -101010
        if let label = viewWithTag(tg) {
            (label as? UILabel)?.text = text
            label.sizeToFit()
            bringSubviewToFront(label)
        } else {
            let label = UILabel()
            label.text = text
            label.textAlignment = .natural
            label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.magenta.withAlphaComponent(0.5)
            label.numberOfLines = 0
            label.tag = -101010
            addSubview(label)
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
            label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
            
        }
    }
    /// 디버깅용: 보더에 아웃라인을 그린다.
    func drawOutline(_ color: UIColor = UIColor.red, fill: Bool = false, isFirst: Bool = true) {
        self.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = isFirst ? 1.5: 0.5
        if fill {
            self.layer.backgroundColor = color.withAlphaComponent(0.2).cgColor
        }
        for child in self.subviews {
            if let s = child as? UIStackView {
                s.arrangedSubviews.forEach { $0.drawOutline(color, fill: fill, isFirst: false) }
            } else {
                child.drawOutline(color, fill: fill, isFirst: false)
            }
            
        }
    }
}
