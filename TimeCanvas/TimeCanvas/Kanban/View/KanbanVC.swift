//
//  ViewController.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/5.
//

import Foundation
import UIKit
import Combine

typealias KanbanDataSourceType = KanbanDataSource<TaskCollectionViewCell, SectionHeaderView>
typealias CollectionViewFactoryType = CollectionViewFactory <TaskCollectionViewCell, SectionHeaderView>

class KanbanViewController: UIViewController, UICollectionViewDelegate {
    
    // View model
    var viewModel = KanbanViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // Data
    var kanbanData = KanbanWorkSpaceModel()
    
    // Factory and DataSource
    var collectionViewFactory: CollectionViewFactoryType?
    var kanbanDataSource: KanbanDataSourceType?
    var menuFactory: MenuConfigFactory?
    
    // UI Component
    var kanbanCollectionView: UICollectionView = UICollectionView(
        frame: CGRect(),
        collectionViewLayout: UICollectionViewLayout())
    
    lazy var addSectionButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "plus.app"),
            style: .plain,
            target: self,
            action: #selector(addSectionButtonPressed))
        
        return button
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Select",
            style: .plain,
            target: self,
            action: #selector(selectButtonPressed))
        
        return button
    }()
    
    // MARK: - View Did Load -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init collection factory
        collectionViewFactory = CollectionViewFactoryType(
            layoutConfig: LayoutConfigStandard())
        
        // Init collection view
        kanbanCollectionView = collectionViewFactory?.createCollectionView(bounds: view.bounds) ?? UICollectionView()
        kanbanCollectionView.delegate = self
        kanbanCollectionView.allowsMultipleSelectionDuringEditing = true
        kanbanCollectionView.allowsMultipleSelection = true
        
        // Init Kanban DataSource
        kanbanDataSource = KanbanDataSourceType(
            kanbanData: kanbanData,
            viewModel: viewModel,
            collectionView: kanbanCollectionView)
        
        kanbanCollectionView.dataSource = kanbanDataSource
        
        // Init Factory
        self.menuFactory = MenuConfigFactory(
            viewModel: viewModel,
            collectionView: kanbanCollectionView)
        
        setupNav()
        setupSubviews()
        setupConstranit()
        dataBinding()
    }
    
    func setupNav() {
        self.navigationItem.rightBarButtonItem = addSectionButton
        self.navigationItem.leftBarButtonItem = editButton
    }
    
    func setupSubviews() {
        view.addSubviews([kanbanCollectionView])
    }
    
    func setupConstranit(){
        kanbanCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
    // MARK: - Data Binding
    func dataBinding() {
        
        viewModel.isEditMode.sink { [weak self] updatedValue in
            
            self?.isEditing = updatedValue
            self?.kanbanCollectionView.allowsMultipleSelection = updatedValue
            
            DispatchQueue.main.async {
                self?.kanbanCollectionView.visibleCells.forEach({ cell in
                    cell.contentView.backgroundColor = updatedValue ? .customUltraLightGray: .customLightGray
                })
            }
            
        }.store(in: &cancellables)
    }
    
    // MARK: - Button Action -
    @objc func addSectionButtonPressed() {
        viewModel.appendSection()
    }
    
    @objc func selectButtonPressed() {
        viewModel.toggleEditMode(with: isEditing)
    }
    
    // MARK: - Context menu delegation -
    
    // Context menu delegation
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint) -> UIContextMenuConfiguration? {
        
            let options: [MenuOptions] = [.copy, .rename, .delete]
            return menuFactory?.createContexMenuConfig(
                with: options,
                and: indexPaths)
    }
    
    // MARK: - Collection view delegation -
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard isEditing else {
            collectionView.deselectItem(at: indexPath, animated: false)
            return
        }
            
        DispatchQueue.main.async {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = .blue
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard isEditing else { return }
        
        DispatchQueue.main.async {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.backgroundColor = .customUltraLightGray
        }
    }
}
