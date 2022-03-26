//
//  CollectionViewCellWithPresenter.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import UIKit

class CollectionViewCellWithPresenter: UICollectionViewCell {
    fileprivate var internalPresenter: CellPresenter?
    
    func configure(_ presenter: CellPresenter) {
        internalPresenter = presenter
        didSetup()
    }
    
    func didSetup() {
        
    }
}

class CollectionViewCell<T: CellPresenter>: CollectionViewCellWithPresenter {
    var presenter: T? {
        internalPresenter as? T
    }
    
}

extension UICollectionView {
    func dequeueReusableCell(
        _ indexPath: IndexPath,
        cellPresenter: CellPresenter
    ) -> CollectionViewCellWithPresenter {
        guard
            let cell = dequeueReusableCell(
                withReuseIdentifier: cellPresenter.reusableCellClass.reuseIdentifier,
                for: indexPath
            ) as? CollectionViewCellWithPresenter
        else {
            fatalError()
        }
        cell.configure(cellPresenter)
        return cell
    }
    
    final func register<T: UICollectionViewCell>(cellType: T.Type) where T: Reusable & NibLoadable {
        self.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}
protocol CellPresenter {
    var reusableCellClass: Reusable.Type { get }
}
