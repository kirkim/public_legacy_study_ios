//
//  CoreDataManager.swift
//  CoreDataTest
//
//  Created by 김기림 on 2022/08/29.
//

import Foundation
import CoreData

class CategoryCoreDataManager {
    private var categories = [Category]()
    
    let context = AppDelegate.persistentContainer.viewContext
    
    func loadCategories(completion: @escaping () -> ()) {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
            completion()
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    func saveCategories(completion: @escaping () -> ()) {
        do {
            try context.save()
            completion()
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func addCategories(title: String, completion: @escaping () -> ()) {
        let newCategory = Category(context: context)
        newCategory.name = title
        
        categories.append(newCategory)
        saveCategories(completion: completion)
    }
    
    func getCategory(row: Int) -> Category {
        return categories[row]
    }

    func getCountCategories() -> Int {
        return categories.count
    }
}
