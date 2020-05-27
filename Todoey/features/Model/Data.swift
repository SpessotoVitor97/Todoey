//
//  Data.swift
//  Todoey
//
//  Created by Vitor Spessoto on 5/27/20.
//  Copyright © 2020 Vitor Canevari Spessoto. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}
