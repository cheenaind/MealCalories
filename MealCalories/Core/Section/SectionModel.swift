//
//  SectionModel.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//
import RxDataSources

struct SectionModel<Item> {
    var items: [Item]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}
