//
//  Extensions.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import Foundation

extension ActionError {
    
    func get() -> Error {
        switch self {
        case .underlyingError(let error): return error
        case .notEnabled: return ActionError.notEnabled
        }
    }
}
