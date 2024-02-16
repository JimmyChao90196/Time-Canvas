//
//  KanbanViewModel.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/13.
//

import Foundation
import Combine
import UIKit

enum DataChange {
    case initialize
    
    case deleteSection
    case deleteTask
    case appendSection
    case appenTask(IndexPath)
    case insertSection
    case insertTask
}

protocol KanbanPropertyVMProtocol {
    var kanbanData: CurrentValueSubject<(KanbanWorkSpaceModel, DataChange), Never> { get }
    var isEditMode: PassthroughSubject<Bool, Never> { get }
    var isSelected: PassthroughSubject<Bool, Never> { get }
    var cellColor: PassthroughSubject<UIColor, Never> { get }
}

protocol KanbanAppendVMProtocol {    
    func appendSection()
    func appendTask(within: Section)
    func insertTask(after indexPath: IndexPath)
}

protocol KanbanDeleteVMProtocol {
    func deleteSection()
    func deleteTask(with: [IndexPath])
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
    KanbanDeleteVMProtocol{
    
    var cancellables = Set<AnyCancellable>()
    
    var kanbanData: CurrentValueSubject<(KanbanWorkSpaceModel, DataChange), Never> = .init(
        (KanbanWorkSpaceModel(workSpaceName: "MainWorkSpace"), .initialize))
    
    var isEditMode: PassthroughSubject<Bool, Never> = .init()
    var isSelected: PassthroughSubject<Bool, Never> = .init()
    var cellColor: PassthroughSubject<UIColor, Never> = .init()
    
    init() {
        setupColorBroadcasting()
    }
    
    func appendSection() {
//        let newSection = Section()
//        kanbanData.value.sections.append(newSection)
    }
    
    func deleteSection() {
        
    }
    
    func appendTask(within targetSection: Section) {
        
        var tempValue = kanbanData.value.0
        
        let updatedSections = tempValue.sections.map { section in
            if section.id == targetSection.id {
                var newSection = section
                newSection.tasks.append(Task())
                return newSection
            } else {
                return section
            }
        }
        
        let sectionIndex = updatedSections.firstIndex { $0.id == targetSection.id } ?? 0
        let itemIndex = targetSection.tasks.count
        
        let lastIndexPath = IndexPath(row: itemIndex, section: sectionIndex)
        
        tempValue.sections = updatedSections
        
        kanbanData.value = (tempValue, .appenTask(lastIndexPath))
    }
    
    func insertTask(after indexPath: IndexPath) {
        
    }
    
    func deleteTask(with indexPaths: [IndexPath]) {
        
//        let ids = indexPaths.compactMap { indexPath in
//            return kanbanData.value.sections[indexPath.section].tasks[indexPath.item].id
//        }
//        
//        let updatedSections = kanbanData.value.sections.map { section in
//            var tempSection = section
//            tempSection.tasks.removeAll { task in
//                ids.contains { id in
//                    id == task.id
//                }
//            }
//            return tempSection
//        }
//        
//        kanbanData.value.sections = updatedSections
        
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

    private func setupColorBroadcasting() {
        // Combine isEditMode and isSelected to determine the color to broadcast
        Publishers.CombineLatest(isEditMode, isSelected)
            .map { isEditMode, isSelected -> UIColor in
                switch (isEditMode, isSelected) {
                case (false, _):
                    return .customLightGray
                case (true, false):
                    return .customUltraLightGray
                case (true, true):
                    return .blue
                }
            }
            .subscribe(cellColor)
            .store(in: &cancellables)
    }
}
