//
//  KanbanDataSource.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/13.
//

import Foundation
import UIKit
import Combine

// Typealias
typealias DataSourceVMTypes = KanbanPropertyVMProtocol &
CellPropertyVMProtocol &
CellUtilityVMProtocol &
KanbanAppendVMProtocol &
KanbanDeleteVMProtocol &
KanbanAdvanceVMProtocol

class KanbanDataSource<HeaderType: SectionHeaderProtocol & UICollectionReusableView>:
        NSObject,
        UICollectionViewDataSource,
        UICollectionViewDelegate {
    
    // ViewModel
    var viewModel: DataSourceVMTypes = KanbanViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // Factory
    var menuFactory: MenuConfigFactory?
    
    var kanbanCollectionView = UICollectionView(
        frame: CGRect(),
        collectionViewLayout: UICollectionViewLayout())
    var isEditing: Bool = false
    
    init(kanbanData: KanbanDataProtocol,
         viewModel: DataSourceVMTypes,
         collectionView: UICollectionView) {
        self.kanbanData = kanbanData
        self.viewModel = viewModel
        self.kanbanCollectionView = collectionView
        
        super.init()
        dataBinding()
        
        // Init Factory
        self.menuFactory = MenuConfigFactory(viewModel: viewModel)
    }
    
    var kanbanData: KanbanDataProtocol
    
    func dataBinding() {
        viewModel.isEditMode.sink { [weak self] updatedValue in
            guard let self else { return }
            self.isEditing = updatedValue
            DispatchQueue.main.async {
                self.kanbanCollectionView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.kanbanData.sink { [weak self] updatedValue in
            guard let self else { return }
            
            self.kanbanData = updatedValue.0
            
            DispatchQueue.main.async {
                
                switch updatedValue {
                case (_, .initialize):
                    
                    self.kanbanCollectionView.reloadData()
                    self.viewModel.isEditMode.send(false)
                    
                case (_, .appenTask(let indexPath)):
                    
                    self.kanbanCollectionView.insertItems(at: [indexPath])
                    self.kanbanCollectionView.scrollToItem(
                        at: indexPath,
                        at: .centeredHorizontally,
                        animated: true)
                    
                case (_, .deleteTask(let indexPaths)):
                    
                    
                    self.kanbanCollectionView.deleteItems(at: indexPaths)
                    self.viewModel.isEditMode.send(false)
                    
                    
                case (_, .insertTask(let indexPaths)):
                    
                    self.kanbanCollectionView.insertItems(at: indexPaths)
                    self.viewModel.isEditMode.send(false)
                    
                    
                case (_, .appendSection(let indexSet)):
                    
                    
                    let sectionIndex = self.kanbanData.sections.count - 1
                    self.kanbanCollectionView.insertSections(indexSet)
                    self.kanbanCollectionView.scrollToItem(
                        at: IndexPath(item: 0, section: sectionIndex),
                        at: .bottom,
                        animated: true)
                    
                    
                default: fatalError("Not yet implemented")
                    
                }
            }
            
        }.store(in: &cancellables)
    }
    
    // MARK: - Data Source -
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        kanbanData.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        kanbanData.sections[section].tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = kanbanData.sections[indexPath.section]
        let task = section.tasks[indexPath.row]
        
        return viewModel.cellSwitcher(
            collectionView: collectionView,
            indexPath: indexPath,
            task: task)
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            
            guard var header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderType.reuseIdentifier,
                for: indexPath) as? HeaderType else { return UICollectionReusableView() }
            
            // Assign view model instance
            header.viewModel = viewModel
            header.indexPath = indexPath
            
            let section = kanbanData.sections[indexPath.section]
            header.configure(with: section)
            return header
        }
    
    // MARK: - Context menu delegation -
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint) -> UIContextMenuConfiguration? {
            
            let firstIndexPath = indexPaths.first
            let task = kanbanData
                .sections[firstIndexPath?.section ?? 0]
                .tasks[firstIndexPath?.row ?? 0]
            
            guard task.isUtility == false else { return nil }
        
            let options: [MenuOptions] = [.copy, .insert, .rename, .delete]
            return menuFactory?.createContexMenuConfig(
                with: options,
                and: indexPaths)
    }
    
    // MARK: - Collection view delegation -
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let isUtility = kanbanData.sections[indexPath.section].tasks[indexPath.row].isUtility
        return viewModel.shouldSelect(isUtility: isUtility, isEditing: isEditing)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let isUtility = kanbanData.sections[indexPath.section].tasks[indexPath.row].isUtility
        
        if isUtility {
            collectionView.deselectItem(at: indexPath, animated: true)
            viewModel.insertTask(before: [indexPath])
            return
        }
        
        DispatchQueue.main.async {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = .blue
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let isUtility = kanbanData.sections[indexPath.section].tasks[indexPath.row].isUtility
        
        if isUtility { return }
        
        DispatchQueue.main.async {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = .customUltraLightGray
        }
    }
}

