//
//  Item.swift
//  MyTodo
//
//  Created by Adrian Layne on 7/10/19.
//  Copyright © 2019 Adrian Layne. All rights reserved.
//

import Foundation
class Item : Codable {
    var title : String
    var done : Bool
    
    required init(title : String, done : Bool){
        self.title = title
        self.done = done
    }
}
