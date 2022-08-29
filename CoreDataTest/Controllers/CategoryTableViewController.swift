//
//  CategoryTableViewController.swift
//  CoreDataTest
//
//  Created by 김기림 on 2022/08/28.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    private let categoryCoreDataManager = CategoryCoreDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCoreDataManager.loadCategories {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            self.categoryCoreDataManager.addCategories(title: textField.text!) {
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryCoreDataManager.getCountCategories()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryCoreDataManager.getCategory(row: indexPath.row)
            .name
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.itemCoreDataManager = ItemCoreDataManager(category: categoryCoreDataManager.getCategory(row: indexPath.row))
        }
    }
}
