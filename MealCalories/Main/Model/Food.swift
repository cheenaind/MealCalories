//
//  Food.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

struct Food: Codable {
    let fdcId: Int
    let description: String
    let brandName: String?
    let score: Double?
    let foodNutrients: [Nutrients]?
}
