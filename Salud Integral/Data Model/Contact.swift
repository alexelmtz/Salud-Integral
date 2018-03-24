//
//  Contact.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/15/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var phoneNumber: String = ""
}
