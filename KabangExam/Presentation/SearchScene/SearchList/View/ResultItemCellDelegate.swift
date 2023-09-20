//
//  ResultItemCellDelegate.swift
//  KabangExam
//
//  Created by hyonsoo han on 2023/09/18.
//

import Foundation

protocol ResultItemCellDelegate: AnyObject {
    func didClickCandidateItemCell(text: String) -> Void
    func didClickResultItemCell(id: String) -> Void
}
