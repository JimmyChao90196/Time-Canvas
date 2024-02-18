//
//  ViewController.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/5.
//

import Foundation
import UIKit
import Combine

typealias KanbanDataSourceType = KanbanDataSource< SectionHeaderView>
typealias CollectionViewFactoryType = CollectionViewFactory <KanbanCellVariants, SectionHeaderView>

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
            layoutConfig: LayoutConfigStandard(),
            cellVariants: [.normal, .utility])
        
        // Init collection view
        kanbanCollectionView = collectionViewFactory?.createCollectionView(bounds: view.bounds) ?? UICollectionView()
        kanbanCollectionView.allowsMultipleSelectionDuringEditing = true
        kanbanCollectionView.allowsMultipleSelection = true
        
        // Init Kanban DataSource and Delegate
        kanbanDataSource = KanbanDataSourceType(
            kanbanData: kanbanData,
            viewModel: viewModel,
            collectionView: kanbanCollectionView)
        
        kanbanCollectionView.dataSource = kanbanDataSource
        kanbanCollectionView.delegate = kanbanDataSource
        
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
    
    // MARK: - Data Binding -
    func dataBinding() {
        
        viewModel.isEditMode.sink { [weak self] updatedValue in
            self?.isEditing = updatedValue
            
        }.store(in: &cancellables)
    }
    
    // MARK: - Button Action -
    @objc func addSectionButtonPressed() {
        viewModel.appendSection()
    }
    
    @objc func selectButtonPressed() {
        viewModel.toggleEditMode(with: isEditing)
    }
}
