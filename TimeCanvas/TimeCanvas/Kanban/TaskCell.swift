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
}

class TaskCollectionViewCell: UICollectionViewCell, TaskCellProtocol {
    
    static var cellClass: AnyClass {
        return TaskCollectionViewCell.self
    }
    
    static var identifier = String(describing: TaskCollectionViewCell.self)
    
    private let taskNameLabel = UILabel()
    private let taskDescriptionLabel = UILabel()
    
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
        taskDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        taskDescriptionLabel.textColor = .gray
        contentView.layer.cornerRadius = 10
        
        contentView.addSubviews([
            taskNameLabel,
            taskDescriptionLabel
        ])
        
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
        contentView.backgroundColor = .red
    }
}
