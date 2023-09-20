//
//  RecentsStorage.swift
//  AppStoreSample
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation

protocol RecentsStorage {
    func findRecents(searchTerm: String) async -> [String]
    func saveRecent(searchTerm: String) async -> Void
}
