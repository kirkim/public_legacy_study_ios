//
//  ViewController.swift
//  PracticeMoya
//
//  Created by 김기림 on 2022/09/21.
//

import UIKit
import Moya

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }


}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let provider = MoyaProvider<SampleAPI>()
        provider.request(.searchImage("1", searchBar.text ?? "")) { [weak self] result in
            switch result {
            case let .success(response):
                let result = try? response.map(SearchImage.self)
                
                let url = URL(string: result?.results[0].urls.regular ?? "")
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imageView.image = image
                            }
                        }
                    }
                }
                self?.totalLabel.text = String(result?.total ?? 0) + "개"
                self?.createdAtLabel.text = result?.results[0].createdAt
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
