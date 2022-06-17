//
//  AddressSearchCell.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/15.
//

import UIKit
import SnapKit

class AddressSearchCell: UITableViewCell {
    let addressLabel = UILabel()
    var data: SubAddressByTextData?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: SubAddressByTextData) {
        self.data = data
        addressLabel.text = data.address_name
    }
    
    private func attribute() {
        self.selectionStyle = .none
    }
    
    private func layout() {
        [addressLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        addressLabel.snp.makeConstraints {
            $0.center.equalTo(self.contentView)
        }
    }
}
