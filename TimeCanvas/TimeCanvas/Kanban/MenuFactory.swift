//
//  MenuFactory.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/14.
//

import Foundation
import UIKit
import Combine

enum MenuOptions {
    case copy
    case rename
    case delete
    case archive
    
    var name: String {
        switch self {
        case .copy:
            "Copy Task"
        case .rename:
            "Rename Task"
        case .delete:
            "Delete Task"
        case .archive:
            "Archive Task"
        }
    }
    
    var state: UIMenuElement.State {
        switch self {
        case .copy: return .off
            
        case .rename: return .off
            
        case .delete: return .off
            
        case .archive: return .off
        }
    }
    
    var image: UIImage {
        switch self {
        case .copy:
            return UIImage(systemName: "doc.on.doc")!
        case .rename:
            return UIImage(systemName: "square.and.pencil")!
        case .delete:
            return UIImage(systemName: "trash")!
        case .archive:
            return UIImage(systemName: "archivebox")!
        }
    }
}

class MenuConfigFactory {
    
    // View Model
    var viewModel: KanbanDeleteVMProtocol & KanbanAdvanceVMProtocol = KanbanViewModel()
    
    // Collection View
    var collectionView = UICollectionView(
        frame: CGRect(),
        collectionViewLayout: UICollectionViewLayout())
    
    init(viewModel: KanbanDeleteVMProtocol & KanbanAdvanceVMProtocol,
         collectionView: UICollectionView = UICollectionView(
            frame: CGRect(),
            collectionViewLayout: UICollectionViewLayout())) {
                
        self.viewModel = viewModel
        self.collectionView = collectionView
    }
    
    func createContexMenuConfig(
        title: String = "More options",
        with options: [MenuOptions],
        and indexPaths: [IndexPath]) -> UIContextMenuConfiguration {
            
        UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { suggestedActions -> UIMenu? in
                
                var UIMenuElements = [UIMenuElement]()

                print(indexPaths)
                
                options.forEach { option in
                    
                    let action = UIAction(
                        title: option.name,
                        image: option.image,
                        identifier: nil,
                        discoverabilityTitle: nil,
                        state: option.state) { action in
                            
                            switch option {
                            case .copy:
                                self.viewModel.copyTask()
                            case .rename:
                                self.viewModel.renameTask()
                            case .delete:
                                self.viewModel.deleteTask(with: indexPaths)
                            case .archive:
                                self.viewModel.archiveTask()
                            }
                    }
                    
                    UIMenuElements.append(action)
                }
 
                return UIMenu(title: title, children: UIMenuElements)
            }
    }
}
