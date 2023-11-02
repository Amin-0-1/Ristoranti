//
//  PinterestLayout.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit


protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, layout: PinterestLayout,
                        heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
    func collectionViewHeaderSize(_ collectionView:UICollectionView)->CGFloat
}

extension PinterestLayoutDelegate {
    func collectionViewHeaderSize(_ collectionView:UICollectionView)->CGFloat {return 0}
}

class PinterestLayout: UICollectionViewLayout {
    // MARK: Static Constants
    static let PinterestElementKindSectionHeader: String = UICollectionView.elementKindSectionHeader
    
    typealias AttributeCache = [UICollectionViewLayoutAttributes]
    
    // MARK: Delegate
    weak var delegate: PinterestLayoutDelegate?
    
    // MARK: Cache
    private var itemCache: AttributeCache = []
    private var supplementaryCache: [String: AttributeCache] = [:]

    
    private lazy var contentBounds: CGRect = {
        guard let collectionView = collectionView else { return .zero }
        var size = collectionView.bounds.inset(by: collectionView.contentInset).size
        if let headerSize = supplementaryCache[PinterestLayout.PinterestElementKindSectionHeader]?.first?.frame.size {
            size.height += headerSize.height // Adjust for header view height
        }
        return CGRect(origin: .zero, size: size)
    }()
        
    // MARK: Public Variables
    var cellPadding: CGFloat = 6 {
        didSet {
            if oldValue != cellPadding { invalidateLayout() }
        }
    }
    
    var numberOfColumns = 2 {
        didSet {
            if oldValue != numberOfColumns { invalidateLayout() }
        }
    }
    
    var cellWidth: CGFloat {
        return (contentBounds.width / CGFloat(numberOfColumns)) - 2 * cellPadding
    }
    
    // MARK: - Overrides
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        itemCache.removeAll()
        supplementaryCache.removeAll()
        
        var xOffsets: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        xOffsets = xOffsets.indices.map { CGFloat($0) * contentBounds.width / CGFloat(numberOfColumns) }
        
        var yOffsets: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        let count = collectionView.numberOfItems(inSection: 0)
        
        var column = 0
        var itemIndex = 0
        var adIndex = 0
        
        if let delegate = delegate {
            if delegate.collectionViewHeaderSize(collectionView) > 0 {
                let indexPath = IndexPath(item: adIndex, section: 0)
                let height = delegate.collectionViewHeaderSize(collectionView)
                let frame = CGRect(x: 0,
                                   y: yOffsets.max() ?? 0,
                                   width: contentBounds.width,
                                   height: height)
                
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: Self.PinterestElementKindSectionHeader, with: indexPath)
                attributes.frame = insetFrame
                supplementaryCache.updateCollection(keyedBy: PinterestLayout.PinterestElementKindSectionHeader, with: attributes)
                contentBounds = contentBounds.union(frame)
                yOffsets = yOffsets.map { _ in frame.maxY }
                adIndex += 1
            }
        }
        while itemIndex < count {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            
            let photoHeight = delegate?.collectionView(collectionView, layout: self,
                                                       heightForItemAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let width = contentBounds.width / CGFloat(numberOfColumns)
            let frame = CGRect(x: xOffsets[column],
                               y: yOffsets[column],
                               width: width,
                               height: height)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            itemCache.append(attributes)
            contentBounds = contentBounds.union(frame)
            yOffsets[column] = frame.maxY
            column = yOffsets.indexOfMin ?? 0 // Waterfall Layout
            itemIndex += 1
        }
        
        
    }
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemCache[indexPath.item]
    }
    
    // MARK: - Header view
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == PinterestLayout.PinterestElementKindSectionHeader {
            return supplementaryCache[elementKind]?[indexPath.item]
        }
        return nil
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = [UICollectionViewLayoutAttributes]()
        
        let attributes = binSearchAttributes(in: itemCache, intersecting: rect)
        result.append(contentsOf: attributes)
        
        supplementaryCache.keys.forEach { key in
            if let cache = supplementaryCache[key] {
                let attributes = binSearchAttributes(in: cache, intersecting: rect)
                result.append(contentsOf: attributes)
            }
        }
        
        return result
    }
    
    // MARK: - Helpers
    func binSearchAttributes(in cache: AttributeCache, intersecting rect: CGRect) -> AttributeCache {
        var result = [UICollectionViewLayoutAttributes]()
        
        let start = cache.startIndex
        guard let end = cache.indices.last else { return result }
        
        guard let firstMatchIndex = findPivot(in: cache, for: rect, start: start, end: end) else {
            return result
        }
        
        for attributes in cache[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            result.append(attributes)
        }
        
        for attributes in cache[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            result.append(attributes)
        }
        
        return result
    }
    
    func findPivot(in cache: AttributeCache, for rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }
        
        let mid = (start + end) / 2
        let attr = cache[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return findPivot(in: cache, for: rect, start: (mid + 1), end: end)
            } else {
                return findPivot(in: cache, for: rect, start: start, end: (mid - 1))
            }
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

extension Array where Element: Comparable {
    var indexOfMin: Int? {
        guard let min = self.min() else { return nil }
        return self.firstIndex(of: min)
    }
}

extension String {
    func heightFitting(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return boundingBox.height
    }
}
