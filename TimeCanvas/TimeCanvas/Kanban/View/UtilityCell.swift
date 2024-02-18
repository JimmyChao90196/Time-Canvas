//
//  UtilityCell.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/17.
//

import Foundation
import UIKit
import SnapKit
import Combine

class UtilityCell:
    UICollectionViewCell,
    CellProtocol{
    
    // View model
    var viewModel: CellPropertyVMProtocol = KanbanViewModel() {
        didSet { dataBinding() }
    }
    var cancellables = Set<AnyCancellable>()
    
    // Static Property
    static var cellClass: AnyClass {
        return UtilityCell.self
    }
    static var identifier = String(describing: UtilityCell.self)
    
    // UI Elements
    private let plusImage = UIImageView(image: UIImage(systemName: "plus.viewfinder")!)
    
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
        contentView.addSubviews([plusImage])
        
        contentView.backgroundColor = .customUltraLightGray.withAlphaComponent(0.25)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor
            .customLightGray
            .withAlphaComponent(0.25)
            .cgColor
        
        plusImage.contentMode = .scaleAspectFit
        plusImage.tintColor = .lightGray.withAlphaComponent(0.25)
        
        plusImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(plusImage.snp.height).multipliedBy(1.0)
        }
    }
    
    func configureAppearence(with task: Task) {
        contentView.backgroundColor = task.taskColor.hexToColor()
    }
    
    func dataBinding() {
        cancellables = []
        viewModel.isEditMode
            .receive(on: RunLoop.main)
            .sink { [weak self] updatedData in
                self?.contentView.isHidden = updatedData
                self?.plusImage.isHidden = updatedData
            }
            .store(in: &cancellables)
    }
}
