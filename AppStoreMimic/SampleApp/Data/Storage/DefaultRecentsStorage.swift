//
//  DefaultRecentsStorage.swift
//  AppStoreMimic
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation

final class DefaultRecentsStorage {
    static let theKey = "recents"
    static let maxCount = 100
    
    private var memory: [String] = []
    private let store: UserDefaults
    
    init(store: UserDefaults = UserDefaults.standard) {
        self.store = store
    }
    
    private func loadMemoryIfNeed() -> [String] {
        if self.memory.isEmpty {
            self.memory = self.store.stringArray(forKey: DefaultRecentsStorage.theKey) ?? []
        }
        return self.memory
    }
}

extension DefaultRecentsStorage: RecentsStorage {
    func findRecents(searchTerm: String) async -> [String] {
        return await Task.detached(priority: .userInitiated) { [weak self] in
            guard let this = self else { return [] }
            let list = this.loadMemoryIfNeed()
            if searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return list
            }
            return list.filter({ $0.starts(with: searchTerm) })
        }.value
    }
    
    func saveRecent(searchTerm: String) async {
        await Task.detached { [weak self] in
            guard let this = self else { return }
            var list = this.loadMemoryIfNeed()
            if list.contains(where: { $0 == searchTerm }) {
                return
            }
            list.insert(searchTerm, at: 0)
            if list.count > DefaultRecentsStorage.maxCount {
                list.removeLast()
            }
            this.store.set(list, forKey: DefaultRecentsStorage.theKey)
            this.memory = list
        }.value
    }
}
