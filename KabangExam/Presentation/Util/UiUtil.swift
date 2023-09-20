//
//  UiUtil.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/20.
//

import UIKit

final class UiUtil {
    static func makeLine() -> UIView {
        let line = UIView()
        line.backgroundColor = .systemGray4
        return line
    }
    
    static func makeDetailHeadLabel(text: String) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.font = .boldSystemFont(ofSize: 24)
        return lb
    }
}
