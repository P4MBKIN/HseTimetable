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
    case auth
    
    func returnType() -> [String: String]? {
        var headers: [String: String]? = nil
        
        switch self {
        case .lessons:
            headers = [String: String]()
            headers?["platform"] = "ios"
            headers?["app"] = "hse-timetable-case"
            headers?["version"] = "1.0.0"
            headers?["id"] = "-1"
            
        case .auth:
            headers = [String: String]()
            headers?["platform"] = "ios"
            headers?["app"] = "hse-timetable-case"
            headers?["version"] = "1.0.0"
            headers?["id"] = "-1"
        }
        return headers
    }
}
