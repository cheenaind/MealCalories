//
//  UIColor+Extensions.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formattedHex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Remove the leading "#" if it exists
        if formattedHex.hasPrefix("#") {
            formattedHex.remove(at: formattedHex.startIndex)
        }
        
        // Ensure the string is exactly 6 characters
        guard formattedHex.count == 6 else {
            return nil
        }
        
        // Convert the hex string to an integer
        var rgbValue: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        // Initialize UIColor with hex integer
        self.init(hex: Int(rgbValue), alpha: alpha)
    }
}
