//
//  String+Extensions.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

import UIKit

public extension String {
    var reuseId: String { self }

    var nib: UINib { UINib(nibName: self, bundle: nil) }
}
