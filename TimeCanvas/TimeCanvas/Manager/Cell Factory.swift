//
//  ColorManager.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/17.
//

import Foundation
import UIKit
import Combine

protocol CellVariantsProtocol {
    var identifier: String { get }
    var cellClass: UICollectionViewCell.Type { get }
}

enum KanbanCellVariants: CellVariantsProtocol {

    case normal
    case utility
    
    var cellClass: UICollectionViewCell.Type {
        switch self {
        case .normal:
            return TaskCollectionViewCell.self
        case .utility:
            return UtilityCell.self
        }
    }
    
    var identifier: String {
        switch self {
        case .normal:
            return TaskCollectionViewCell.identifier
        case .utility:
            return UtilityCell.identifier
        }
    }
}

// MARK: - Cell Switcher -
protocol CellFactoryProtocol {
    func createCell(
        collectionView: UICollectionView,
        indexPath: IndexPath) -> UICollectionViewCell
}

class CellFactory<CellType: CellProtocol> {
    
    func createCell(
        collectionView: UICollectionView,
        indexPath: IndexPath) -> CellType {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CellType.identifier,
                for: indexPath) as? CellType else { return TaskCollectionViewCell() as! CellType }
            
            return cell
        }
}

