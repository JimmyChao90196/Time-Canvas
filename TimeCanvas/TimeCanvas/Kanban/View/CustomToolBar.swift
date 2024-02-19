//
//  CustomToolBar.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/19.
//

import Foundation
import UIKit
import Combine
import SnapKit

class CustomToolBar: UIVisualEffectView {
    
    // Type Alias VM Type
    typealias VMType = KanbanDeleteVMProtocol & KanbanAdvanceVMProtocol & KanbanAppendVMProtocol
    
    // VM
    let viewModel: VMType
    
    // Factory
    let menuFactory: MenuConfigFactory
    
    // UI
    let blurEffect = UIBlurEffect(style: .systemMaterialLight)
    var showMoreButton = UIButton(type: .custom)
    
    init(viewModel: VMType, menuFactory: MenuConfigFactory){
        self.viewModel = viewModel
        self.menuFactory = menuFactory
        super.init(effect: blurEffect)
        setupViews()
        setupConstranit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Functions
    func setupViews() {
        self.contentView.addSubviews([showMoreButton])
        
        showMoreButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        showMoreButton.addTarget(self, action: #selector(showMoreOption), for: .touchUpInside)
        showMoreButton.contentMode = .center
        showMoreButton.imageView?.contentMode = .scaleAspectFit
        showMoreButton.configuration = .plain()
        showMoreButton.showsMenuAsPrimaryAction = true
    }
    
    func setupConstranit() {
        
        showMoreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(showMoreButton.snp.height)
        }
    }
    
    @objc func showMoreOption() {
        print("show options")
    }
}
