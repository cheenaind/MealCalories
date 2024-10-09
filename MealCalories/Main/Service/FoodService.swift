//
//  FoodService.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

import RxSwift

protocol FoodService {
    func initalLoad(query: String, brand: String, page: Int, numberOfItems: Int) -> Observable<FoodResponse>
    func loadNext(query: String, brand: String) -> Observable<FoodResponse>
}

final class FoodServiceProxy: FoodService {
    private var page: Int = 1
    private var numberOfItems: Int = 10
    
    func initalLoad(query: String, brand: String, page: Int, numberOfItems: Int) -> Observable<FoodResponse> {
        let repository: FoodRepository = FoodRepositoryProxy(page: page, numberOfItems: numberOfItems, query: query, brand: brand)
        return repository.get()
    }
    
    func loadNext(query: String, brand: String) -> Observable<FoodResponse> {
        let repository: FoodRepository = FoodRepositoryProxy(page: page, numberOfItems: numberOfItems, query: query, brand: brand)
        return repository.get()
    }
}
