//
//  FlowCoordinator.swift
//  AppStoreMimic
//
//  Created by hyonsoo on 2023/09/20.
//

import Foundation

///  연관된 화면들의 흐름을 제공
protocol FlowCoordinator {
    /// 첫 화면 시작
    func start() -> Void
}
