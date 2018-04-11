//
//  Item.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/8/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var frequency: String = ""
    @objc dynamic var reminder: Date?
    @objc dynamic var dateCreated: Date?
    let datesCompleted = List<History>()
    var parentCategory = LinkingObjects(fromType: Section.self, property: "items")
}
