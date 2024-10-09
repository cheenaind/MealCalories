import UIKit
import RxSwift
import RxCocoa

// MARK: - Cell Reuse

protocol Reusable {
    static var reuseId: String { get }
    static var nib: UINib { get }
}

extension UICollectionView {
    func dequeue<Tile: UICollectionViewCell>(_ tile: Tile.Type, for indexPath: IndexPath) -> Tile where Tile: UICollectionViewCell {
        dequeueReusableCell(withReuseIdentifier: tile.reuseId, for: indexPath) as! Tile
    }
    
    func register<Tile: UICollectionViewCell>(_ tile: Tile.Type, isXib: Bool = false) where Tile: UICollectionViewCell {
        if isXib {
            register(tile.nib, forCellWithReuseIdentifier: tile.reuseId)
        } else {
            register(tile, forCellWithReuseIdentifier: tile.reuseId)
        }
    }
}

// MARK: - Reusable Views Reuse

enum ReusableViewKind {
    case header
    case footer
    
    public var key: String {
        switch self {
        case .header:
            return UICollectionView.elementKindSectionHeader
        case .footer:
            return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionView {
    func dequeue<Tile: UICollectionReusableView>(
        _ tile: Tile.Type,
        kind: ReusableViewKind,
        for indexPath: IndexPath
    ) -> Tile where Tile: UICollectionViewCell {
        dequeueReusableSupplementaryView(ofKind: kind.key, withReuseIdentifier: tile.reuseId, for: indexPath) as! Tile
    }
    
    func register<Tile: UICollectionReusableView>(_ tile: Tile.Type, kind: ReusableViewKind, isXib: Bool = false) where Tile: UICollectionViewCell {
        if isXib {
            register(tile.nib, forSupplementaryViewOfKind: kind.key, withReuseIdentifier: tile.reuseId)
        } else {
            register(tile, forSupplementaryViewOfKind: kind.key, withReuseIdentifier: tile.reuseId)
        }
    }
}

// MARK: - RxSwift Extensions for UICollectionView

extension Reactive where Base: UICollectionView {
    func items<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
    (_ cellClass: Cell.Type)
    -> (_ source: Source)
    -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
    -> Disposable where Source.Element == Sequence, Cell: UICollectionViewCell {
        return { source in
            return { configureCell in
                return source.bind(to: self.base.rx.items(cellIdentifier: cellClass.reuseId, cellType: cellClass)) { index, element, cell in
                    configureCell(index, element, cell)
                }
            }
        }
    }
}

public extension Reactive where Base: UIScrollView {

  var reachedBottom: ControlEvent<Void> {
    let observable = contentOffset
      .flatMap { [scrollView = base] contentOffset -> Observable<Void> in
        let contentInsetVertical = scrollView.contentInset.top + scrollView.contentInset.bottom
        let visibleHeight = scrollView.frame.height - contentInsetVertical
        let contentOffsetY = contentOffset.y + scrollView.contentInset.top
        let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

        return contentOffsetY > threshold ? Observable.just(()) : Observable.empty()
      }

    return ControlEvent(events: observable)
  }
}
