//
//  ViewController.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/5.
//

import Foundation
import UIKit
import Combine

class KanbanViewController: UIViewController, UICollectionViewDataSource {

    let layoutFactory = LayoutFactory(layoutConfig: LayoutConfigStandard())
    let kanbanData: KanbanDataProtocol = KanbanWorkSpaceModel(workSpaceName: "MainWorkSpace")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension KanbanViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        kanbanData.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        kanbanData.sections[section].taskNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}


