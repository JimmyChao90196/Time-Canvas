//
//  KanbanDataSource.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/13.
//

import Foundation
import UIKit
import Combine

class KanbanDataSource<
    CellType: TaskCellProtocol & UICollectionViewCell,
    HeaderType: SectionHeaderProtocol & UICollectionReusableView>:
        NSObject,
        UICollectionViewDataSource,
        UICollectionViewDelegate {
    
    // Typealias
    typealias VMTypes = KanbanPropertyVMProtocol &
    KanbanAppendVMProtocol &
    KanbanDeleteVMProtocol &
    KanbanAdvanceVMProtocol
    
    // ViewModel
    var viewModel: VMTypes = KanbanViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // Data
    var menuFactory: MenuConfigFactory?
    
    var kanbanCollectionView = UICollectionView(
        frame: CGRect(),
        collectionViewLayout: UICollectionViewLayout())
    var isEditing: Bool = false
    
    init(kanbanData: KanbanDataProtocol,
         viewModel: VMTypes,
         collectionView: UICollectionView) {
        self.kanbanData = kanbanData
        self.viewModel = viewModel
        self.kanbanCollectionView = collectionView
        
        super.init()
        dataBinding()
        
        // Init Factory
        self.menuFactory = MenuConfigFactory(
            viewModel: viewModel,
            collectionView: kanbanCollectionView)
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
            
            switch updatedValue {
            case (_, .initialize):
                
                DispatchQueue.main.async {
                    self.kanbanCollectionView.reloadData()
                    self.viewModel.isEditMode.send(false)
                }
                
            case (_, .appenTask(let indexPath)):
                
                DispatchQueue.main.async {
                    self.kanbanCollectionView.insertItems(at: [indexPath])
                }
                
            case (_, .deleteTask(let indexPaths)):
                
                DispatchQueue.main.async {
                    self.kanbanCollectionView.deleteItems(at: indexPaths)
                    self.viewModel.isEditMode.send(false)
                }
                
            case (_, .insertTask(let indexPaths)):
                DispatchQueue.main.async {
                    self.kanbanCollectionView.insertItems(at: indexPaths)
                    self.viewModel.isEditMode.send(false)
                }
                
            case (_, .appendSection(let indexSet)):
                DispatchQueue.main.async {
                    
                    let sectionIndex = self.kanbanData.sections.count - 1
                    self.kanbanCollectionView.insertSections(indexSet)
                    self.kanbanCollectionView.scrollToItem(
                        at: IndexPath(item: 0, section: sectionIndex),
                        at: .bottom,
                        animated: true)
                }
                
            default: fatalError("Not yet implemented")
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
        guard var cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellType.identifier,
            for: indexPath) as? CellType else { return UICollectionViewCell() }
        
        let section = kanbanData.sections[indexPath.section]
        let task = section.tasks[indexPath.row]
        
        // Assign view model
        cell.viewModel = viewModel
        
        // Config Cell Content
        cell.configure(with: task)
        
        return cell
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
        
            let options: [MenuOptions] = [.copy, .insert, .rename, .delete]
            return menuFactory?.createContexMenuConfig(
                with: options,
                and: indexPaths)
    }
    
    // MARK: - Collection view delegation -
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        isEditing ? true: false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = .blue
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = .customUltraLightGray
        }
    }
}
