//
//  Cell.swift
//  CoreDataTest
//
//  Created by 김기림 on 2022/08/27.
//

import UIKit

class Cell: UITableViewCell {
    static let reuseIdentifier = "Cell"
    
    private let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let checkLabel:UILabel = {
        let label = UILabel()
        label.text = "✔"
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ data: Item) {
        label.text = data.title
        checkLabel.isHidden = data.done
    }
    
    private func layout() {
        [label, checkLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        checkLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
    }
}
