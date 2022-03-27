//
//  MosaicLayout.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import UIKit

protocol MosaicLayoutDelegate: AnyObject {
    
}

struct MosaicLayoutConfiguration {
    let numberOfColumns: Int
    let cellsOffset: CGFloat
    
    static let `default`: MosaicLayoutConfiguration = .init(numberOfColumns: 2, cellsOffset: 4)
}

final class MosaicLayout: UICollectionViewLayout {
    // MARK: - Private properties
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // MARK: - Public properties
    
    private(set) var configuration: MosaicLayoutConfiguration = .default
    private(set) var feedModels: [FeedItemModel] = []
    weak var delegate: MosaicLayoutDelegate?
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight + 50)
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
    }
    
    func updateFeedModel(feedModels: [FeedItemModel]) {
        self.feedModels = feedModels
        invalidateLayout()
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }

        let numberOfColumns = configuration.numberOfColumns
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let horizontalOffset: [CGFloat] = (0..<numberOfColumns).map { CGFloat($0) * columnWidth }
        var verticalOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: .zero) {
            let currentColumn = verticalOffset.enumerated().max(by: { $0.element >= $1.element })?.offset ?? 0
            
            let indexPath = IndexPath(item: item, section: .zero)
            let itemSize = feedModels[item]
            let itemHeight = itemSize.ratio * columnWidth
            
            let height = configuration.cellsOffset * 2 + itemHeight
            let frame = CGRect(x: horizontalOffset[currentColumn],
                               y: verticalOffset[currentColumn],
                               width: columnWidth,
                               height: height)
            let cellFrame = frame.insetBy(dx: configuration.cellsOffset, dy: configuration.cellsOffset)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = cellFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            verticalOffset[currentColumn] = verticalOffset[currentColumn] + height
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[indexPath.item]
    }
}
