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
    case insert
    case rename
    case delete
    case archive
    
    var name: String {
        switch self {
        case .copy:
            "Copy Task"
        case .insert:
            "Insert Task"
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
            
        case .insert: return .off
            
        case .rename: return .off
            
        case .delete: return .off
            
        case .archive: return .off
        }
    }
    
    var image: UIImage {
        switch self {
        case .copy:
            return UIImage(systemName: "doc.on.doc")!
        case . insert:
            return UIImage(systemName: "chevron.right.square")!
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
    
    // Type Alias
    typealias VMType = KanbanDeleteVMProtocol & KanbanAdvanceVMProtocol & KanbanAppendVMProtocol
    
    // View Model
    var viewModel: VMType = KanbanViewModel()
    
    init(viewModel: VMType) {
        self.viewModel = viewModel
    }
    
    func createMenu(
        title: String,
        with options: [MenuOptions],
        and indexPaths: [IndexPath]) -> UIMenu {
            
            var UIMenuElements = [UIMenuElement]()
            
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
                        case .insert:
                            self.viewModel.insertTask(before: indexPaths)
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
    
    func createContexMenuConfig(
        title: String = "More options",
        with options: [MenuOptions],
        and indexPaths: [IndexPath]) -> UIContextMenuConfiguration {
            
            UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: nil) { suggestedActions -> UIMenu? in
                    
                    self.createMenu(
                        title: title,
                        with: options,
                        and: indexPaths)
                }
        }
}
