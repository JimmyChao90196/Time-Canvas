//
//  KanbanViewModel.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/13.
//

import Foundation
import Combine
import UIKit

protocol KanbanBasicProtocol {
    func appendSection()
    func deleteSection()
    func appendTask(within: Section)
    func deleteTask(with: IndexPath)
}

protocol KanbanAdditionalOptionsProtocol {
    func copyTask()
    func renameTask()
    func archiveTask()
}

class KanbanViewModel: KanbanBasicProtocol, KanbanAdditionalOptionsProtocol {

    @Published var kanbanData: KanbanDataProtocol = KanbanWorkSpaceModel(workSpaceName: "MainWorkSpace")
    
    func appendSection() {
        let newSection = Section()
        kanbanData.sections.append(newSection)
    }
    
    func deleteSection() {
        
    }
    
    func appendTask(within targetSection: Section) {
        kanbanData.sections = kanbanData.sections.map { section in
            if section.id == targetSection.id {
                var newSection = section
                newSection.tasks.append(Task())
                return newSection
            } else {
                return section
            }
        }
    }
    
    func deleteTask(with indexPath: IndexPath) {
        print(indexPath)
        kanbanData.sections[indexPath.section].tasks.remove(at: indexPath.row)
    }
    
    func copyTask() {
        
    }
    
    func renameTask() {
        
    }
    
    func archiveTask() {
        
    }
}
