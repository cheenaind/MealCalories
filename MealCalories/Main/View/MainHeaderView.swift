//
//  MainHeaderView.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

import UIKit
import RxSwift

final class MainHeaderView: UIView {
    var query: PublishSubject<String> = .init()
    var brand: PublishSubject<String> = .init()
    
    private let disposeBag = DisposeBag()
    
    private var menuQueries: [String] = ["PRIMA DONNA", "QUESOS LA RICURA LTD.", "SARTORI", "CITRUS GINGER BELLAVITANO", "KOOL TART", "MIFROMA", "SAPORI DI CASA", "MARBLE JACK", "SUPREME"]
    let searchBar: SearchTextField = {
        let bar = SearchTextField()
        bar.clearButtonMode = .always
        bar.placeholder = "Type name..."
        return bar
    }()
    
    private let brandButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "Brand name"
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        config.titlePadding = 10
        config.imagePadding = 10
        config.baseBackgroundColor = .background02
        config.baseForegroundColor = .text02
        config.imagePlacement = .trailing
        button.configuration = config
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialLayout()
        configureView()
    }
    
    private func setupInitialLayout() {
        addSubview(searchBar)
        addSubview(brandButton)
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        
        brandButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureView() {
        brandButton.backgroundColor = .background02
        searchBar.backgroundColor = .background02
        
        brandButton.layer.cornerRadius = 12
        searchBar.layer.cornerRadius = 12
        
        brandButton.setTitle("Brand name", for: .normal)
        
        let actionClosure = { [unowned self] (action: UIAction) in
            self.brand.onNext(action.title)
            self.brandButton.setTitle(action.title, for: .normal)
            
        }
        var menuItems: [UIMenuElement] = []
        
        menuQueries.forEach { query in
            menuItems.append(UIAction(title: query, handler: actionClosure))
        }
        
        brandButton.menu = UIMenu(options: .displayInline, children: menuItems)
        brandButton.showsMenuAsPrimaryAction = true
        
        searchBar.rx.text.subscribe { [unowned self] value in
            self.query.onNext(value ?? "")
        }.disposed(by: disposeBag)
    }
}
