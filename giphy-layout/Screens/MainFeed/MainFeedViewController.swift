//
//  MainFeedViewController.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import UIKit

protocol MainFeedInteractionInput: AnyObject {
    func update(cellPresenters: [GyphyImagePresenter])
    func routeToPreview(with id: String)
    func showMessage(_ message: FeedMessage)
}

class MainFeedViewController: UIViewController, MainFeedInteractionInput {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private(set) var presenter: MainFeedPresentationOutput?
    var dataSource: MainFeedViewDataSource?
    
    var routeToPreview: ((String) -> UIViewController?)?
    
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
    
    func routeToPreview(with id: String) {
        guard let vc = routeToPreview?(id) else { return }
        present(vc, animated: true)
    }
    
    func showMessage(_ message: FeedMessage) {
        messageLabel.text = message.title
        messageLabel.sizeToFit()
        messageContainer.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 3, options: [.curveEaseInOut]) {
            self.messageContainer.alpha = 0
        } completion: { _ in }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.select(at: indexPath)
    }
}
