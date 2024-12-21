//
//  ItemCoreDataManager.swift
//  CoreDataTest
//
//  Created by 김기림 on 2022/08/29.
//

import Foundation
import CoreData

class ItemCoreDataManager {
    let context = AppDelegate.persistentContainer.viewContext
    var itemArray: [Item] = []
    var category: Category?
    
    init(category: Category) {
        self.category = category
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil, completion: @escaping () -> ()) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
            completion()
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func addItem(title: String, completion: @escaping () -> ()) {
        let newItem = Item(context: context)
        newItem.title = title
        newItem.done = false
        newItem.parentCategory = category
        itemArray.append(newItem)
        
        saveItems(completion: completion)
    }
    
    private func saveItems(completion: @escaping () -> ()) {
        do {
            try context.save()
            completion()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func toggleDone(row: Int, completion: @escaping () -> ()) {
        itemArray[row].done = !itemArray[row].done
        saveItems(completion: completion)
    }
    
    func getItem(row: Int) -> Item {
        return itemArray[row]
    }
    
    func getItemsCount() -> Int {
        return itemArray.count
    }
}
