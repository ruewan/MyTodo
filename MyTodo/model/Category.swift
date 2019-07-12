//
//  Category.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/11/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
