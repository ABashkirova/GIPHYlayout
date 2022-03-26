//
//  MainFeedViewController.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import UIKit

class MainFeedViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GyphyViewCell.self, forCellWithReuseIdentifier: "GyphyViewCell")
        if let layout = collectionView.collectionViewLayout as? MosaicLayout {
            layout.delegate = self
        }
    }

}

extension MainFeedViewController: MosaicLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return [CGFloat(100), 180, 120, 150].randomElement() ?? 60
    }
}

extension MainFeedViewController: UICollectionViewDelegate {
    
}

extension MainFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GyphyViewCell", for: indexPath)
        cell.backgroundColor = Colors.MainPalette.allCases.randomElement()?.uiColor
        return cell
    }
}
