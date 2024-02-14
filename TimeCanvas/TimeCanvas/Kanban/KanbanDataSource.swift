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
        UICollectionViewDataSource {
    
    // ViewModel
    var viewModel = KanbanViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    init(kanbanData: KanbanDataProtocol,
         viewModel: KanbanViewModel,
         collectionView: UICollectionView) {
        self.kanbanData = kanbanData
        self.viewModel = viewModel
        
        super.init()
        dataBinding()
    }
    
    var kanbanData: KanbanDataProtocol
    
    func dataBinding() {
        viewModel.$kanbanData.sink { [weak self] updatedValue in
            self?.kanbanData = updatedValue
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
            
            let section = kanbanData.sections[indexPath.section]
            header.configure(with: section)
            return header
        }
}
