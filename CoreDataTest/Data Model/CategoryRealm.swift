//
//  Category.swift
//  CoreDataTest
//
//  Created by 김기림 on 2022/08/30.
//

import Foundation
import RealmSwift

class CategoryRealm: Object {
    @Persisted var name: String = ""
    @Persisted var items: List<ItemRealm>
}
