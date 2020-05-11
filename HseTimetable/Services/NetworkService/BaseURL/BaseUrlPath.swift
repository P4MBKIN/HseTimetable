//
//  BaseUrlPath.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

enum BaseUrlPathType {
    case lessons
    case auth
}

enum BaseUrlPath {
    
    case lessons
    case auth(email: String)

    var rawValue: String {
        switch self {
        case .lessons: return "/ruz/lessons"
        case .auth(let email):   return "/dump/email/\(email)"
        }
    }
}
