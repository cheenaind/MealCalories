//
//  MainViewModel.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

import RxSwift

final class MainViewModel {
    private let service: FoodService
    
    private lazy var manager = PaginationManager<FoodResponse> { [unowned self] page, limit, query, brand in
        return self.service.initalLoad(query: query, brand: brand, page: page, numberOfItems: limit)
    }
    
    lazy var adapter = PaginationAdapter(manager: manager)

    struct Input {
        let initialLoad: (query: Observable<String>, brand: Observable<String>)
    }
    
    struct Output {
        let info: Observable<[SectionModel<Food>]>
    }
    
    init(service: FoodService) {
        self.service = service
    }
    
    func transform(_ input: Input) -> Output {
        let data: Observable<[SectionModel<Food>]> = manager.contentUpdate
            .map {
                return [SectionModel(items: $0)]
            }
        
        return .init(info: data)
    }
}
