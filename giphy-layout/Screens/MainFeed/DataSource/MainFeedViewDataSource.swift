//
//  MainFeedViewDataSource.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 27.03.2022.
//

import UIKit

final class MainFeedViewDataSource: NSObject, UICollectionViewDataSource {
    private(set) var cellPresenters: [GyphyImagePresenter] = []
   
    func updateCellModel(cellPresenters: [GyphyImagePresenter]) {
        self.cellPresenters = cellPresenters
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellPresenters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(indexPath, cellPresenter: cellPresenters[indexPath.row]) as? GyphyViewCell else {
            return UICollectionViewCell()
        }
        cell.colorView?.backgroundColor = Colors.MainPalette.allCases.randomElement()?.uiColor
        return cell
    }
}
