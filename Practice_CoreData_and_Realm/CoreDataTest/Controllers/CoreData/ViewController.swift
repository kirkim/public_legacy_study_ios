//
//  ViewController.swift
//  CoreDataTest
//
//  Created by 김기림 on 2022/08/26.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var itemCoreDataManager: ItemCoreDataManager? {
        didSet {
            itemCoreDataManager?.loadItems {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        searchBar.delegate = self
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Today Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            self.itemCoreDataManager?.addItem(title: textField.text!, completion: {
                self.tableView.reloadData()
            })
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}


//MARK: - TableView
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCoreDataManager?.getItemsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        if let item = itemCoreDataManager?.getItem(row: indexPath.row) {
            cell.configure(item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemCoreDataManager?.toggleDone(row: indexPath.row, completion: {
            tableView.reloadData()
        })
        
        //MARK: 삭제 로직
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - SearchBar
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        itemCoreDataManager?.loadItems(with: request, predicate: predicate, completion: {
            self.tableView.reloadData()
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            itemCoreDataManager?.loadItems {
                self.tableView.reloadData()
            }
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

