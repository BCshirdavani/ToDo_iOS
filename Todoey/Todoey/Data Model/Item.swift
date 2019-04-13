//
//  Item.swift
//  Todoey
//
//  Created by shiMac on 4/12/19.
//  Copyright © 2019 code stuff. All rights reserved.
//

import Foundation
import RealmSwift


class Item : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
