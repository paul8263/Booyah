//
//  User.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation

class User {
    var userId: String
    var displayName: String
    
    init(userId: String, displayName: String) {
        self.userId = userId
        self.displayName = displayName
    }
}
