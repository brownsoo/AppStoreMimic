//
//  iTunesRepository.swift
//  AppStoreSample
//
//  Created by hyonsoo on 2023/09/17.
//

import Foundation
import Combine

protocol iTunesRepository {
    
    func saveSearchTerm(_ term: String) -> Cancellable
    
    /// 최근 검색어 조회
    /// - Parameters:
    ///   - term: 검색어
    ///   - onResult: 검색 결과
    /// - Returns: 조회 태스크
    @discardableResult
    func searchRecents(_ term: String, onResult: @escaping([String]) -> Void) -> Cancellable
    
    
    /// 소프트웨어 조회
    /// - Parameters:
    ///   - term: 검색어
    ///   - onResult: 검색 결과
    /// - Returns: 조회 태스크
    func searchSoftware(_ term: String, onResult: @escaping(Result<[Software], Error>) -> Void) -> Cancellable
}
