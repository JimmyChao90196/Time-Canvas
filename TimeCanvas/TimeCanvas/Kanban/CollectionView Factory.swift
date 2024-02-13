//
//  CollectonView Factory.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/12.
//

import Foundation
import UIKit

protocol LayoutConfigProtocol {
    var contentInsetsValue: Double { get }
    var itemSize: NSCollectionLayoutSize { get }
    var groupSize: NSCollectionLayoutSize { get }
    var headerSize: NSCollectionLayoutSize { get }
}

// Candidate Layouts
class LayoutConfigSmall: LayoutConfigProtocol {
    var contentInsetsValue: Double = 5
    var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(0.25))
    var groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
}

class LayoutConfigStandard: LayoutConfigProtocol {
    var contentInsetsValue: Double = 10
    var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
    var groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
}

class LayoutConfigBig: LayoutConfigProtocol {
    var contentInsetsValue: Double = 15
    var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    var groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
}

class CollectionViewConfigFactory {
    
    // MARK: - Initializer -
    init(
        layoutConfig: LayoutConfigProtocol,
        cellType: TaskCellProtocol.Type,
        headerType: SectionHeaderProtocol.Type
    ) {
        self.layoutConfig = layoutConfig
        self.cellType = cellType
        self.headerType = headerType
    }

    // Config CollectionView
    var layoutConfig: LayoutConfigProtocol
    var headerType: SectionHeaderProtocol.Type
    var cellType: TaskCellProtocol.Type
    
    private func createItem() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: layoutConfig.itemSize)
        let insetValue = layoutConfig.contentInsetsValue
        item.contentInsets = NSDirectionalEdgeInsets(top: insetValue, leading: insetValue, bottom: insetValue, trailing: insetValue)
        return item
    }
    
    private func createGroup() -> NSCollectionLayoutGroup {
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutConfig.groupSize, subitems: [createItem()])
        return group
    }
    
    public func createLayoutGuide() -> UICollectionViewCompositionalLayout {
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutConfig.headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        let section = NSCollectionLayoutSection(group: createGroup())
        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    public func createCollectionView(bounds: CGRect) -> UICollectionView {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayoutGuide())
        collectionView.register(cellType.cellClass, forCellWithReuseIdentifier: cellType.identifier)
        
        collectionView.register(
            headerType.headerClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerType.reuseIdentifier)
        
        return collectionView
    }
}
