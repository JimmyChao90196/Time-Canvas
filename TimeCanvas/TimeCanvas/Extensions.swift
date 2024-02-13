//
//  AddMultipleSubview.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/12.
//

import Foundation
import UIKit

// MARK: - Add multiple subview
extension UIView {
    
    @discardableResult
    func addSubviews(_ views: [UIView]) -> Self {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        return self
    }
}
