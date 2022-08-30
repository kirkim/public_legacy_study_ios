//
//  Item.swift
//  CoreDataTest
//
//  Created by 김기림 on 2022/08/30.
//

import Foundation
import RealmSwift

class ItemRealm: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<CategoryRealm>
}
