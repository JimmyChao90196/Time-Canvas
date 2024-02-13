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
}

class SectionHeaderView: UICollectionReusableView, SectionHeaderProtocol {
    static let reuseIdentifier = String(describing: SectionHeaderView.self)
    static var headerClass: AnyClass {
        return SectionHeaderView.self
    }
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubviews([titleLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
