//
//  KanbanViewModel.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/13.
//

import Foundation
import Combine
import UIKit

protocol KanbanBasicVMProtocol {
    var kanbanData: CurrentValueSubject<KanbanWorkSpaceModel, Never> { get }
    var isEditMode: CurrentValueSubject<Bool, Never> { get }
    
    func appendSection()
    func deleteSection()
    func appendTask(within: Section)
    func deleteTask(with: IndexPath)
    
    // Additional
    func toggleEditMode()
}

protocol KanbanAdditionalVMProtocol {
    func copyTask()
    func renameTask()
    func archiveTask()
}

class KanbanViewModel: KanbanBasicVMProtocol, KanbanAdditionalVMProtocol {
    
    var kanbanData: CurrentValueSubject<KanbanWorkSpaceModel, Never> = .init(
        KanbanWorkSpaceModel(workSpaceName: "MainWorkSpace"))
    
    var isEditMode: CurrentValueSubject<Bool, Never> = .init(false)
    
    
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
    func toggleEditMode() {
        isEditMode.value.toggle()
    }
}
