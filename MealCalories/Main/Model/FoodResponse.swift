//
//  FoodResponse.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

struct FoodResponse: Codable, Pagination {
    var items: [Food] { foods }
    
    typealias Content = Food
    
    var hasNext: Bool { currentPage < totalPages }
    
    let totalHits: Int
    let currentPage: Int
    let totalPages: Int
    let foods: [Food]
}
