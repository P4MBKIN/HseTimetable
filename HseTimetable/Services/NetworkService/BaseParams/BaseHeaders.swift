//
//  BaseHeaders.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

enum BaseHeaders {
    
    case lessons
    
    func returnType() -> [String: String]? {
        var headers: [String: String]? = nil
        switch self {
        case .lessons:
            headers = nil
        }
        return headers
    }
}