//
//  Section.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/8/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import Foundation
import RealmSwift

class Section: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var imageName: String = ""
    let items = List<Item>()
    let inactiveItems = List<Item>()
}
