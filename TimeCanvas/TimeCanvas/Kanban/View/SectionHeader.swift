//
//  SectionHeader.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/12.
//

import Foundation
import UIKit

protocol SectionHeaderProtocol {
    
    static var reuseIdentifier: String { get }
    static var headerClass: AnyClass { get }
    
    var viewModel: KanbanAppendVMProtocol { get set }
    var section: Section { get set }
    var indexPath: IndexPath { get set }
    
    func configure(with section: Section)
}

class SectionHeaderView: UICollectionReusableView, SectionHeaderProtocol {
    
    // Register info
    static let reuseIdentifier = String(describing: SectionHeaderView.self)
    static var headerClass: AnyClass {
        return SectionHeaderView.self
    }
    
    // Essential Data
    var section: Section = Section()
    var indexPath: IndexPath = IndexPath()
    
    // View Model
    var viewModel: KanbanAppendVMProtocol = KanbanViewModel()
    
    // UI Component
    let titleLabel = UILabel()
    
    lazy var addTaskButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        button.backgroundColor = .blue
        button.setImage(UIImage(systemName: "plus.viewfinder"), for: .normal)
        button.addTarget(self, action: #selector(addTaskButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubviews([titleLabel, addTaskButton])
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        addTaskButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.trailing.equalToSuperview().offset(-5)
        }
    }
    
    func configure(with section: Section) {
        self.section = section
        titleLabel.text = section.name
    }
    
    // MARK: - Add Task -
    @objc func addTaskButtonPressed() {
        viewModel.appendTask(within: self.section)
    }
}
