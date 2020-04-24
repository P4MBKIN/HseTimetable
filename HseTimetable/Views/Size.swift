//
//  Padding.swift
//  HseTimetable
//
//  Created by Pavel on 20.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import Foundation

enum Size {
    
    case common
    case double
    case small
    case large
    
    var indent: CGFloat {
        switch self {
        case .common: return 5.0
        case .double: return Size.common.indent * 2
        case .small: return 2.5
        case .large: return 20.0
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .common: return 15.0
        case .double: return Size.double.cornerRadius * 2
        case .small: return 5.0
        case .large: return 25.0
        }
    }
    
    var font: CGFloat {
        switch self {
        case .common: return 15.0
        case .double: return Size.common.font * 2
        case .small: return 12.0
        case .large: return 25.0
        }
    }
}
