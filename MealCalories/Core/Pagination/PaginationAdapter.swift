import UIKit
import RxSwift

final class PaginationAdapter<Page: Pagination> {
    
    private let disposeBag = DisposeBag()
    
    private let manager: PaginationManager<Page>
    
    init(manager: PaginationManager<Page>) {
        self.manager = manager
    }
    
    func start() {
        manager.loadNextIfNeeded(retry: true)
    }
    
    func restart() {
        manager.resetData()
    }
    
    func connect(to collectionView: UICollectionView) {
        let refresher = collectionView.refreshControl
        collectionView.rx.reachedBottom
            .subscribe(onNext: { [weak manager] in
                manager?.loadNextIfNeeded()
            })
            .disposed(by: disposeBag)
        
        refresher?.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak manager] in
                manager?.resetData()
            })
            .disposed(by: disposeBag)
        
        manager.stateChange
            .filter { !$0.isLoading }
            .subscribe(onNext: { _ in
                refresher?.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    func connect(toTextChange textChange: Observable<String>, toBrand brand: Observable<String>) {
        Observable.merge(
            textChange.map { query in (query, nil) },
            brand.map { brand in (nil, brand) }
        )
        .do(onNext: { [weak manager] query, brand in
            if let query = query {
                manager?.update(query: query, brand: manager?.brand ?? "")
            } else if let brand = brand {
                manager?.update(query: query ?? "", brand: brand)
            }
        })
        .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak manager] _ in
            manager?.resetData()
        })
        .disposed(by: disposeBag)
    }
}
