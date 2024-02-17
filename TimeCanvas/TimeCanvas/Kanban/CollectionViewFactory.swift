//
//  CollectonView Factory.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/12.
//

import Foundation
import UIKit

protocol LayoutConfigProtocol {
    
    // Insets
    var contentInsetsValue: Double { get }
    
    // Sizes
    var itemSize: NSCollectionLayoutSize { get }
    var horizontalGroupSize: NSCollectionLayoutSize { get }
    var verticalGroupSize: NSCollectionLayoutSize { get }
    var headerSize: NSCollectionLayoutSize { get }
    
    // Scrolling Behavior
    var scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior { get }
}

// Candidate Layouts
class LayoutConfigSmall: LayoutConfigProtocol {
    
    let contentInsetsValue: Double = 5
    
    var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.3333))
    
    var verticalGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.3333),
        heightDimension: .fractionalHeight(1.0))
    
    var horizontalGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.25))
    
    let headerSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44))
    
    let scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .groupPaging
}

class LayoutConfigStandard: LayoutConfigProtocol {
    var contentInsetsValue: Double = 10
    
    var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.5))
    
    var verticalGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.5),
        heightDimension: .fractionalHeight(1.0))
    
    var horizontalGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.25))
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
    
    let scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .groupPaging
}

class LayoutConfigBig: LayoutConfigProtocol {
    
    var contentInsetsValue: Double = 10
    
    var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0))
    
    var verticalGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.5),
        heightDimension: .fractionalHeight(1.0))
    
    var horizontalGroupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.25))
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
    
    let scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .groupPaging
}

class CollectionViewFactory<
    VariantType: CellVariantsProtocol,
    HeaderType: SectionHeaderProtocol & UICollectionReusableView> {
    
    // MARK: - Initializer -
    init(
        layoutConfig: LayoutConfigProtocol,
        cellVariants: [VariantType]
    ) {
        self.layoutConfig = layoutConfig
        self.cellVariants = cellVariants
    }
    
    // Config CollectionView
    var cellVariants: [CellVariantsProtocol]
    var layoutConfig: LayoutConfigProtocol
    
    private func createItem() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: layoutConfig.itemSize)
        let insetValue = layoutConfig.contentInsetsValue
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: insetValue,
            leading: insetValue,
            bottom: insetValue,
            trailing: insetValue)
        
        return item
    }
    
    private func createGroup() -> NSCollectionLayoutGroup {
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutConfig.verticalGroupSize,
            subitems: [createItem()])
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutConfig.horizontalGroupSize,
            subitems: [verticalGroup])
        
        return horizontalGroup
    }
    
    public func createLayoutGuide() -> UICollectionViewCompositionalLayout {
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutConfig.headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: createGroup())
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = layoutConfig.scrollingBehavior
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    public func createCollectionView(bounds: CGRect) -> UICollectionView {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayoutGuide())
        
        cellVariants.forEach { variant in
            collectionView.register(variant.cellClass, forCellWithReuseIdentifier: variant.identifier)
        }
        
        collectionView.register(
            HeaderType.headerClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderType.reuseIdentifier)
        
        return collectionView
    }
}

