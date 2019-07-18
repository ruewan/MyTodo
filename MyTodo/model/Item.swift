//
//  Item.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/11/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import Foundation
import RealmSwift
class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
