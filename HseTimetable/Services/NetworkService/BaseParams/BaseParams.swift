//
//  BaseParams.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

enum BaseParams {
    
    case lessons
    case auth
    
    func returnType() -> [String: String]? {
        var params: [String: String]? = nil
        
        switch self {
        case .lessons:
            params = nil
            
        case .auth:
            params = nil
        }
        return params
    }
}
