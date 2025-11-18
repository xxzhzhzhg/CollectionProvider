//
//  CollectionSection.swift
//  Syncv
//
//  Created by xxsdf on 2025/10/22.
//

import UIKit

public protocol CollectionItem {
    
    var cellClass: UICollectionViewCell.Type { get }

    var onSelect: (() -> Void)? { get }

    func cellForItem(cell: UICollectionViewCell)
}

public extension CollectionItem {
    
    func toAny() -> CollectionItem{
        return self
    }
}

public protocol CollectionSection {
    associatedtype Identifier: Hashable
    
    var id: Identifier { get set }
    
    var items: [CollectionItem] { get set }

    func numberOfItems() -> Int
    func cellForItem(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func didSelectItem(at indexPath: IndexPath)
    
    func headerView(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView?
    func footerView(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView?
}

public extension CollectionSection {
    func numberOfItems() -> Int { items.count }

    func cellForItem(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: item.cellClass),
            for: indexPath
        )
        item.cellForItem(cell: cell)
        return cell
    }

    func didSelectItem(at indexPath: IndexPath) {
        guard indexPath.item < items.count else { return }
        items[indexPath.item].onSelect?()
    }

    func headerView(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView? { nil }
    func footerView(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView? { nil }
}

public struct AnyCollectionSection<ID: Hashable>: CollectionSection {
    public var id: ID
    public var items: [CollectionItem]

    public init(id: ID, items: [CollectionItem]) {
        self.id = id
        self.items = items
    }
}

