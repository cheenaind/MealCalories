//
//  SearchTextField.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

import UIKit

class SearchTextField: UITextField {
    var textPadding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12) // Set your custom insets
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}
