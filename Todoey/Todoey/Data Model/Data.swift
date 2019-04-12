//
//  Data.swift
//  Todoey
//
//  Created by shiMac on 4/11/19.
//  Copyright © 2019 code stuff. All rights reserved.
//

import Foundation
import RealmSwift


class Data: Object {
    // use dynamic dispatch, not standard static, this requires @objc
    // realm can change values of dynamic variables during runtime
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
