//
//  Task.swift
//  Booyah
//
//  Created by Paul Zhang on 4/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Task {
    var title: String
    var description: String
    var date: Date
    var userId: String
    var address: String
    var latitude: Double
    var longitude: Double
    var ref: FIRDatabaseReference?
    
    
    
    init(title: String = "", description: String = "", date: Date = Date(), userId: String = "", address: String = "", latitude: Double = 0.0, longitude: Double = 0.0) {
        self.title = title
        self.description = description
        self.date = date
        self.userId = userId
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot) {
        
    }
}
