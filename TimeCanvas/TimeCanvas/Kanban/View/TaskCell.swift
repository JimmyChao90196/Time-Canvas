//
//  TaskCell.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/12.
//

import Foundation
import UIKit
import SnapKit
import Combine

protocol CellProtocol: UICollectionViewCell {
    static var cellClass: AnyClass { get }
    static var identifier: String { get }
    var viewModel: CellPropertyVMProtocol { get set }
    func configureAppearence(with task: Task)
}

class TaskCollectionViewCell:
    UICollectionViewCell,
        CellProtocol{
    
    // View model
    var viewModel: CellPropertyVMProtocol = KanbanViewModel() {
        didSet {
            dataBinding()
        }
    }
    var cancellables = Set<AnyCancellable>()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        cancellables = []
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
    
    func configureAppearence(with task: Task) {
        taskNameLabel.text = task.taskName
        taskDescriptionLabel.text = task.taskDescription
    }
    
    func dataBinding() {
        cancellables = []
        viewModel.isEditMode
            .receive(on: RunLoop.main)
            .sink { [weak self] updatedData in
                self?.contentView.backgroundColor = updatedData ?
                    .customUltraLightGray: .customLightGray
            }
            .store(in: &cancellables)
    }
}
