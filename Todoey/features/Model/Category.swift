//
//  Category.swift
//  Todoey
//
//  Created by Vitor Spessoto on 6/17/20.
//  Copyright © 2020 Vitor Canevari Spessoto. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = String()
    let items = List<Item>()
}
