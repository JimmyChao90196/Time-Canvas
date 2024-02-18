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
    var factory: any CellFactoryProtocol { get }
}

protocol CellFactoryProtocol {
    
    associatedtype CellType: CellProtocol
    
    func createCell(
        collectionView: UICollectionView,
        indexPath: IndexPath) -> CellType
}

extension CellFactoryProtocol {
    func createCell(
        tableView: UITableView,
        indexPath: IndexPath) -> CellType { return CellType() }
}

// MARK: - CellVariants -
enum KanbanCellVariants: CellVariantsProtocol, CaseIterable {

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
    
    var factory: any CellFactoryProtocol {
        switch self {
        case .normal:
            return CellFactory<TaskCollectionViewCell>()
        case .utility:
            return CellFactory<UtilityCell>()
        }
    }

}

// MARK: - Cell Factory -
class CellFactory<CellType: CellProtocol & UICollectionViewCell>: CellFactoryProtocol{
    
    typealias CellType = CellType
    
    func createCell(
        collectionView: UICollectionView,
        indexPath: IndexPath) -> CellType {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CellType.identifier,
                for: indexPath) as? CellType else { return CellType() }
            
            return cell
        }
}

