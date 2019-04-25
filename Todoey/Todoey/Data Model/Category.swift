//
//  Category.swift
//  Todoey
//
//  Created by shiMac on 4/12/19.
//  Copyright © 2019 code stuff. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
