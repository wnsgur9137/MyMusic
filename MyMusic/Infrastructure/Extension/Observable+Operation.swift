//
//  Observable+Operation.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/11/24.
//

import Foundation
import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
