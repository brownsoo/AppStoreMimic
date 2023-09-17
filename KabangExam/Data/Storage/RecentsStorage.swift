//
//  RecentsStorage.swift
//  KabangExam
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation

protocol RecentsStorage: Actor {
    nonisolated func findRecents(searchTerm: String) async -> [String]
    func saveRecent(searchTerm: String) -> Void
}
