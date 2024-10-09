//
//  ViewController.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

import UIKit
import RxSwift
import RxDataSources

class ViewController: UIViewController {
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    private let rootView = MainView()
    
    private let query: BehaviorSubject<String> = .init(value: "")
    private let brand: BehaviorSubject<String> = .init(value: "")
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        title = "Breakfast"
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            .init(initialLoad: (query, brand))
        )
        
        let adapter = viewModel.adapter
        adapter.connect(to: rootView.collectionView)
        
        adapter.connect(toTextChange: rootView.headerView.query, toBrand: rootView.headerView.brand)
        
        adapter.start()
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Food>>(
                configureCell: { dataSource, collectionView, indexPath, item in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseId, for: indexPath) as! MainCollectionViewCell
                    cell.setupData(item)
                    return cell
                }
            )
        
        output
            .info
            .bind(to: rootView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
