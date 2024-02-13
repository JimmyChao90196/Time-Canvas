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

class KanbanViewController: UIViewController {
    
    // View model
    var viewModel = KanbanViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // Data
    var kanbanData = KanbanWorkSpaceModel()
    
    // Factory and DataSource
    var collectionViewFactory: CollectionViewFactoryType?
    var kanbanDataSource: KanbanDataSourceType?
    
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
    
    // MARK: - View Did Load -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init kanban DataSource
        kanbanDataSource = KanbanDataSourceType(
            kanbanData: kanbanData,
            viewModel: viewModel)
        
        // Init collection factory
        collectionViewFactory = CollectionViewFactoryType(
            layoutConfig: LayoutConfigStandard())
        
        kanbanCollectionView = collectionViewFactory?.createCollectionView(bounds: view.bounds) ?? UICollectionView()
        kanbanCollectionView.dataSource = kanbanDataSource
        
        setupNav()
        setupSubviews()
        setupConstranit()
        dataBinding()
    }
    
    func setupNav() {
        self.navigationItem.rightBarButtonItem = addSectionButton
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
        viewModel.$kanbanData.sink { [weak self] updatedValue in
            print(updatedValue)
            self?.kanbanCollectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    @objc func addSectionButtonPressed() {
        viewModel.appendSection()
    }
}
