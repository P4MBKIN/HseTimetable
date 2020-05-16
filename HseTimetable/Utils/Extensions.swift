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
import UIKit
import Foundation

extension ActionError {
    
    func get() -> Error {
        switch self {
        case .underlyingError(let error): return error
        case .notEnabled: return ActionError.notEnabled
        }
    }
}

extension Array where Element: Equatable {
    
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ $0.element == element }).map({ $0.offset })
    }
}

extension UIColor {
    
    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
            guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }

            return UIColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
}

extension UIView {
    
    func getSelectedTextView() -> UIView? {
        let totalResults = getTextViewsInView(view: self)
        
        for textView in totalResults{
            if textView.isFirstResponder{
                return textView
            }
        }
        
        return nil
    }
    
    func getPositionOfSubview(subview: UIView) -> CGRect? {
        guard checkViewIsSubview(view: subview) else { return nil }
        guard var secondView = subview.superview else { return nil }
        var currentView: UIView = subview
        var position: CGRect = subview.frame
        
        while secondView != self {
            guard let firstView = secondView.superview else { return nil }
            currentView = secondView
            secondView = firstView
            position = secondView.convert(position, from: currentView)
        }
        
        return position
    }
    
    private func checkViewIsSubview(view: UIView) -> Bool {
        for subview in self.subviews as [UIView] {
            if subview == view { return true }
            if checkViewIsSubview(view: subview) { return true }
        }
        return false
    }
    
    private func getTextViewsInView(view: UIView) -> [UIView] {
        var totalResults = [UIView]()
        
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                totalResults.append(textField)
            } else if let textView = subview as? UITextView {
                totalResults.append(textView)
            } else {
                totalResults.append(contentsOf: getTextViewsInView(view: subview))
            }
        }
        
        return totalResults
    }
}
