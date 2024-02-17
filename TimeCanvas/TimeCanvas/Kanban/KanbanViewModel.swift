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
    case deleteTask([IndexPath])
    case appendSection(IndexSet)
    case appenTask(IndexPath)
    case insertSection
    case insertTask([IndexPath])
}

protocol KanbanPropertyVMProtocol {
    var kanbanData: CurrentValueSubject<(KanbanWorkSpaceModel, DataChange), Never> { get }
}

protocol CellPropertyVMProtocol {
    var isEditMode: PassthroughSubject<Bool, Never> { get }
    var isSelected: PassthroughSubject<Bool, Never> { get }
    var cellColor: PassthroughSubject<UIColor, Never> { get }
}

protocol KanbanAppendVMProtocol {    
    func appendSection()
    func appendTask(within: Section)
    func insertTask(before indexPaths: [IndexPath])
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
    KanbanDeleteVMProtocol,
    CellPropertyVMProtocol {
    
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
        var tempValue = kanbanData.value.0
        
        let newSection = Section()
        let indexSet = IndexSet(integer: kanbanData.value.0.sections.count)
        
        tempValue.sections.append(newSection)
        
        kanbanData.value = (tempValue, .appendSection(indexSet))
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
        
        // Find insert indexPath
        let sectionIndex = updatedSections.firstIndex { $0.id == targetSection.id } ?? 0
        let itemIndex = tempValue.sections[sectionIndex].tasks.count
        let lastIndexPath = IndexPath(row: itemIndex, section: sectionIndex)
        
        // Apply the final value and publish
        tempValue.sections = updatedSections
        kanbanData.value = (tempValue, .appenTask(lastIndexPath))
    }
    
    func insertTask(before indexPaths: [IndexPath]) {
        var tempValue = kanbanData.value.0
        
        for indexPath in indexPaths {
            var targetSection = tempValue.sections[indexPath.section]
            targetSection.tasks.insert(Task(), at: indexPath.item)
            tempValue.sections[indexPath.section] = targetSection
        }
        
        kanbanData.value = (tempValue, .insertTask(indexPaths))
    }
    
    func deleteTask(with indexPaths: [IndexPath]) {
        
        var tempValue = kanbanData.value.0
        let ids = indexPaths.compactMap { indexPath in
            return tempValue.sections[indexPath.section].tasks[indexPath.item].id
        }
        
        let updatedSections = tempValue.sections.map { section in
            var tempSection = section
            tempSection.tasks.removeAll { task in
                ids.contains { id in
                    id == task.id
                }
            }
            return tempSection
        }
        
        // Apply the final value and publish
        tempValue.sections = updatedSections
        kanbanData.value = (tempValue, .deleteTask(indexPaths))
    }
    
    func copyTask() {
        
    }
    
    func renameTask() {
        
    }
    
    func archiveTask() {
        
    }
    
    // MARK: - Additional -
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
