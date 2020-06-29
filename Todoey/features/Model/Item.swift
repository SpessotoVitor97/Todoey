//
//  Item.swift
//  Todoey
//
//  Created by Vitor Spessoto on 6/17/20.
//  Copyright © 2020 Vitor Canevari Spessoto. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = String()
    @objc dynamic var done = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
