//
//  Color.swift
//  HseTimetable
//
//  Created by Pavel on 20.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    static let lightBlue = UIColor(rgb: 0xc0e0f0)
    static let softBlue = UIColor(rgb: 0x5591e6)
    static let lightRed = UIColor(rgb: 0xf0c0c0)
    static let softRed = UIColor(rgb: 0xe65555)
    static let lightGreen = UIColor(rgb: 0xc0f0c0)
    static let softGreen = UIColor(rgb: 0x57e655)
}

extension UIColor {
    
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
