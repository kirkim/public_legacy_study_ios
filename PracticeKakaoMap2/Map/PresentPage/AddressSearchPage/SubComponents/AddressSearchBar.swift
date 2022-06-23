//
//  AddressSearchBar.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddressSearchBar: UISearchBar {
    private let disposeBag = DisposeBag()
    private var viewModel: AddressSearchBarViewModel?
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: AddressSearchBarViewModel) {
        self.viewModel = viewModel
    }
    
    private func attribute() {
        self.placeholder = "지번, 도로명, 건물명으로 검색"
        self.delegate = self
        self.clipsToBounds = true
        self.searchBarStyle = .minimal
        self.backgroundColor = .white
        self.searchTextField.layer.cornerRadius = 10
    }
    
    private func layout() {
        
    }
}

extension AddressSearchBar: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchTextField.layer.borderWidth = 3
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchTextField.layer.borderWidth = 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
        viewModel?.submitText.accept(searchBar.text ?? "")
    }
}
