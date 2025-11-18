//
//  CollectionSectionProvider.swift
//  Syncv
//
//  Created by xxsdf on 2025/10/22.
//

import UIKit

public class CollectionCoordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    public var sections: [CollectionItem] = []
    public var headerProvider: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionReusableView)?
    public var footerProvider: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionReusableView)?

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.item]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: item.cellClass),
            for: indexPath
        )
        item.cellForItem(cell: cell)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.item].onSelect?()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let headerProvider = headerProvider {
                return headerProvider(collectionView, indexPath)
            }
            return UICollectionReusableView()
        case UICollectionView.elementKindSectionFooter:
            if let footerProvider = footerProvider {
                return footerProvider(collectionView, indexPath)
            }
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
}

public class CollectionSectionProvider: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    public var sections: [any CollectionSection] = []
   
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].numberOfItems()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections[indexPath.section].cellForItem(in: collectionView, at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.section].didSelectItem(at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        if kind == UICollectionView.elementKindSectionHeader,
           let header = section.headerView(in: collectionView, at: indexPath) {
            return header
        }
        if kind == UICollectionView.elementKindSectionFooter,
           let footer = section.footerView(in: collectionView, at: indexPath) {
            return footer
        }
        return UICollectionReusableView()
    }
}

public extension UICollectionView {
    func registerCells(_ cellTypes: [UICollectionViewCell.Type]) {
        cellTypes.forEach { cellType in
            register(cellType, forCellWithReuseIdentifier: cellType.identifier)
        }
    }
}
