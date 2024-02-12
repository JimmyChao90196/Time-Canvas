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
}

// Candidate Layouts
class LayoutConfigSmall: LayoutConfigProtocol {
    var contentInsetsValue: Double = 5
    var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(0.25))
    var groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
}

class LayoutConfigStandard: LayoutConfigProtocol {
    var contentInsetsValue: Double = 10
    var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
    var groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
}

class LayoutConfigBig: LayoutConfigProtocol {
    var contentInsetsValue: Double = 15
    var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    var groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
}

class LayoutFactory {
    
    init(layoutConfig: LayoutConfigProtocol) {
        self.layoutConfig = layoutConfig
    }

    // Config Layout
    var layoutConfig: LayoutConfigProtocol
    
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
        let section = NSCollectionLayoutSection(group: createGroup())
        return UICollectionViewCompositionalLayout(section: section)
    }
}
