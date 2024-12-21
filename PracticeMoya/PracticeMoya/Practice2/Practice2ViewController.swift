//
//  Practice2ViewController.swift
//  PracticeMoya
//
//  Created by 김기림 on 2022/09/21.
//

import UIKit

class Practice2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = ListUserRequest(page: 2)
        ListUserAPI.getUserList(request: request) { succeed, failed in
            guard let succeed = succeed else {
                print(failed ?? #function)
                return
            }
            
            let listUser = succeed
            print("listUser: ", listUser)
        }
    }
}
