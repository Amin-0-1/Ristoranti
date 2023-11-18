//
//  PinterestLayout.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        layout: PinterestLayout,
        heightForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat
    func collectionViewHeaderSize(_ collectionView: UICollectionView) -> CGFloat
}

extension PinterestLayoutDelegate {
    func collectionViewHeaderSize(_ collectionView: UICollectionView) -> CGFloat {return 0}
}

class PinterestLayout: UICollectionViewLayout {
    var numberOfColumns = 2
    var cellPadding: CGFloat = 16
    var verticalSpacing: CGFloat = 16
    typealias AttributeCache = [UICollectionViewLayoutAttributes]
    
    private var itemCache: AttributeCache = []
    private var supplementaryCache: [String: AttributeCache] = [: ]
    
    private var contentHeight: CGFloat = 0
    
    var contentWidth: CGFloat {
        return (collectionViewContentSize.width / CGFloat(numberOfColumns)) - 2 * cellPadding
    }
    
    static let PinterestElementKindSectionHeader: String = UICollectionView.elementKindSectionHeader
    
    weak var delegate: PinterestLayoutDelegate?
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        // Handle updates to the collection view, if needed.
        super.prepare(forCollectionViewUpdates: updateItems)
        invalidateLayout()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and add attributes to the visibleLayoutAttributes array if they intersect with the rect.
        for attributes in itemCache where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }
        
        for (_, supplementaryAttributes) in supplementaryCache {
            for attributes in supplementaryAttributes where attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemCache[indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == PinterestLayout.PinterestElementKindSectionHeader {
            return supplementaryCache[elementKind]?[indexPath.item]
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.frame.width ?? 0, height: contentHeight)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.size != collectionView?.bounds.size
    }
    
    override func prepare() {
        // Ensure the cache is empty before we start building it.
        itemCache.removeAll()
        supplementaryCache.removeAll()
        
        guard let collectionView = collectionView else { return }
        
        // Calculate xOffset based on the updated bounds
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * collectionView.frame.size.width / CGFloat(numberOfColumns))
        }
        
        var yOffset: [CGFloat] = Array(repeating: 0, count: numberOfColumns)
        
        if let delegate = delegate {
            // MARK: - height of header if exists
            if delegate.collectionViewHeaderSize(collectionView) > 0 {
                let indexPath = IndexPath(item: 0, section: 0)
                let itemHeight = delegate.collectionViewHeaderSize(collectionView)
                let frame = CGRect(x: 0, y: yOffset.max() ?? 0, width: contentWidth, height: itemHeight)
                
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: Self.PinterestElementKindSectionHeader,
                    with: indexPath
                )
                attributes.frame = insetFrame
                supplementaryCache.updateCollection(
                    keyedBy: PinterestLayout.PinterestElementKindSectionHeader,
                    with: attributes
                )
                contentHeight = frame.maxY
                yOffset = yOffset.map { _ in frame.maxY }
            }
        }
        
        var column = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let width = collectionView.frame.size.width / CGFloat(numberOfColumns) - cellPadding * 2
            
            let itemHeight = delegate?.collectionView(
                collectionView,
                layout: self,
                heightForItemAtIndexPath: indexPath) ?? 0
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: width, height: itemHeight )
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            itemCache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += itemHeight + verticalSpacing
            
            column = (column + 1) % numberOfColumns
        }
    }
}

extension Dictionary where Value: RangeReplaceableCollection {
    mutating func updateCollection(keyedBy key: Key, with element: Value.Element) {
        if var collection = self[key] {
            collection.append(element)
            self[key] = collection
        } else {
            var collection = Value()
            collection.append(element)
            self[key] = collection
        }
    }
}

extension String {
    func pinterestHeightFitting(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return boundingBox.height
    }
}
