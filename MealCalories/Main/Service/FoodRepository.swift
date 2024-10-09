//
//  FoodRepository.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

import RxSwift

protocol FoodRepository {
    func get() -> Observable<FoodResponse>
}

final class FoodRepositoryProxy: FoodRepository {
    private let page: Int
    private let numberOfItems: Int
    private let query: String
    private let brand: String
    private let networkManager = NetworkManager()
    
    init(
        page: Int,
        numberOfItems: Int,
        query: String,
        brand: String
    ) {
        self.page = page
        self.numberOfItems = numberOfItems
        self.query = query
        self.brand = brand
    }
    
    func get() -> Observable<FoodResponse> {
        let params = [
            "query": query,
            "pageNumber": page,
            "brandOwner": brand,
            "pageSize": numberOfItems,
            "api_key": "kcgIBpFWbibkFdsvgGOyuyiM39B3VSxMOjE5nlQ7"
        ] as [String : Any]
        
        return networkManager.fetch(url: "https://api.nal.usda.gov/fdc/v1/foods/search", parameters: params)
    }
}
