//
//  MainFeedViewController.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import UIKit

protocol MainFeedInteractionInput: AnyObject {
    func update(cellPresenters: [GyphyImagePresenter])
}

class MainFeedViewController: UIViewController, MainFeedInteractionInput {
    @IBOutlet weak var collectionView: UICollectionView!
    private(set) var presenter: MainFeedPresentationOutput?
    var dataSource: MainFeedViewDataSource?
    
    convenience init(presenter: MainFeedPresentationOutput) {
        self.init()
        self.presenter = presenter
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(cellType: GyphyViewCell.self)
        presenter?.moduleDidLoad()
    }
    
    func update(cellPresenters: [GyphyImagePresenter]) {
        dataSource?.updateCellModel(cellPresenters: cellPresenters)
        if let layout = collectionView.collectionViewLayout as? MosaicLayout {
            layout.updateFeedModel(feedModels: cellPresenters.map { $0.feedItem })
        }
        collectionView.reloadData()
    }
    
}

extension MainFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        presenter?.willDisplay(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter?.endDisplaying(at: indexPath)
    }
}
