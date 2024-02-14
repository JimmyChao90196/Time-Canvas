//
//  KanbanViewModel.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/13.
//

import Foundation
import Combine
import UIKit


protocol KanbanPropertyVMProtocol {
    var kanbanData: CurrentValueSubject<KanbanWorkSpaceModel, Never> { get }
    var isEditMode: PassthroughSubject<Bool, Never> { get }
}

protocol KanbanAppendVMProtocol {    
    func appendSection()
    func appendTask(within: Section)
}

protocol KanbanDeleteVMProtocol {
    func deleteSection()
    func deleteTask(with: IndexPath)
}

protocol KanbanAdvanceVMProtocol {
    func copyTask()
    func renameTask()
    func archiveTask()
}

class KanbanViewModel:
    KanbanPropertyVMProtocol,
    KanbanAppendVMProtocol,
    KanbanAdvanceVMProtocol,
    KanbanDeleteVMProtocol {
    
    var kanbanData: CurrentValueSubject<KanbanWorkSpaceModel, Never> = .init(
        KanbanWorkSpaceModel(workSpaceName: "MainWorkSpace"))
    
    var isEditMode: PassthroughSubject<Bool, Never> = .init()
    
    func appendSection() {
        let newSection = Section()
        kanbanData.value.sections.append(newSection)
    }
    
    func deleteSection() {
        
    }
    
    func appendTask(within targetSection: Section) {
        kanbanData.value.sections = kanbanData.value.sections.map { section in
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
        kanbanData.value.sections[indexPath.section].tasks.remove(at: indexPath.row)
    }
    
    func copyTask() {
        
    }
    
    func renameTask() {
        
    }
    
    func archiveTask() {
        
    }
    
    // Additional
    func toggleEditMode(with isEditing: Bool) {
        isEditMode.send(!isEditing)
    }
}
