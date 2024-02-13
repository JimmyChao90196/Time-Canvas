//
//  ViewController.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/5.
//

import Foundation
import UIKit
import Combine

class KanbanViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let collectionViewConfigFactory = CollectionViewConfigFactory(
        layoutConfig: LayoutConfigStandard(),
        cellType: TaskCollectionViewCell.self,
        headerType: SectionHeaderView.self
    )
    
    var kanbanCollectionView: UICollectionView = UICollectionView(
        frame: CGRect(),
        collectionViewLayout: UICollectionViewLayout())
    
    let kanbanData: KanbanDataProtocol = KanbanWorkSpaceModel(workSpaceName: "MainWorkSpace")
    
    // MARK: - View Did Load -
    override func viewDidLoad() {
        super.viewDidLoad()
        kanbanCollectionView = collectionViewConfigFactory.createCollectionView(bounds: view.bounds)
        kanbanCollectionView.dataSource = self
        kanbanCollectionView.delegate = self
        
        setupSubviews()
        setupConstranit()
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
}

// MARK: - CollectionView DataSource -
extension KanbanViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        kanbanData.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        kanbanData.sections[section].taskNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TaskCollectionViewCell.identifier,
            for: indexPath) as? TaskCollectionViewCell else { return UICollectionViewCell() }
        
        let section = kanbanData.sections[indexPath.section]
        let task = section.tasks[indexPath.row]
        
        cell.configure(with: task)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }
            
            let sectionTitle = kanbanData.sections[indexPath.section].name
            header.configure(with: sectionTitle)
            return header
    }
}

