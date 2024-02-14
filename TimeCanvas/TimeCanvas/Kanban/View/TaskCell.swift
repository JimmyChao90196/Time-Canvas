//
//  TaskCell.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/12.
//

import Foundation
import UIKit
import SnapKit

protocol TaskCellProtocol {
    static var cellClass: AnyClass { get }
    static var identifier: String { get }
    var viewModel: KanbanBasicProtocol { get set }
    func configure(with: Task)
}

class TaskCollectionViewCell: 
    UICollectionViewCell,
        TaskCellProtocol{
    
    // View model
    var viewModel: KanbanBasicProtocol = KanbanViewModel()
    
    // Static Property
    static var cellClass: AnyClass {
        return TaskCollectionViewCell.self
    }
    
    static var identifier = String(describing: TaskCollectionViewCell.self)
    
    // UI Elements
    private let taskNameLabel = UILabel()
    private let taskDescriptionLabel = UILabel()
    
    var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        
        // Setup appearance
        taskNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        taskNameLabel.textColor = .white
        taskDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        taskDescriptionLabel.textColor = .white
        contentView.backgroundColor = .customLightGray
        contentView.layer.cornerRadius = 10
        
        contentView.addSubviews([
            taskNameLabel,
            taskDescriptionLabel,
            optionButton
        ])
        
        optionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        taskNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        taskDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(taskNameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with task: Task) {
        taskNameLabel.text = task.taskName
        taskDescriptionLabel.text = task.taskDescription
    }
}
