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
    static let taskBaseRef = FIRDatabase.database().reference(withPath: "tasks")
    
    var taskId: String
    var title: String
    var description: String
    var date: Date
    var userId: String
    var address: String
    var latitude: Double
    var longitude: Double
    var ref: FIRDatabaseReference?
    
    init(taskId: String = "", title: String = "", description: String = "", date: Date = Date(), userId: String = "", address: String = "", latitude: Double = 0.0, longitude: Double = 0.0) {
        self.taskId = taskId
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
        self.taskId = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        if let title = snapshotValue["title"] as? String {
            self.title = title
        } else {
            self.title = ""
        }
        if let description = snapshotValue["description"] as? String {
            self.description = description
        } else {
            self.description = ""
        }
        if let timestamp = snapshotValue["timestamp"] as? TimeInterval {
            self.date = Date(timeIntervalSince1970: timestamp)
        } else {
            self.date = Date()
        }
        if let userId = snapshotValue["userId"] as? String {
            self.userId = userId
        } else {
            self.userId = ""
        }
        if let address = snapshotValue["address"] as? String {
            self.address = address
        } else {
            self.address = ""
        }
        if let latitude = snapshotValue["latitude"] as? Double {
            self.latitude = latitude
        } else {
            self.latitude = 0.0
        }
        if let longitude = snapshotValue["longitude"] as? Double {
            self.longitude = longitude
        } else {
            self.longitude = 0.0
        }
        self.ref = snapshot.ref
    }
    
    func toDict() -> [String: Any] {
        var taskDict: [String: Any] = ["title": self.title]
        taskDict["description"] = self.description
        taskDict["address"] = self.address
        taskDict["timestamp"] = self.date.timeIntervalSince1970
        taskDict["userId"] = self.userId
        taskDict["latitude"] = self.latitude
        taskDict["longitude"] = self.longitude
        return taskDict
    }
    func save() {
        var newTaskRef: FIRDatabaseReference!
        if self.taskId == "" {
            newTaskRef = Task.taskBaseRef.childByAutoId()
        } else {
            newTaskRef = Task.taskBaseRef.child(self.taskId)
        }
        newTaskRef.setValue(self.toDict())
        self.taskId = newTaskRef.key
        self.ref = newTaskRef
    }
    func delete() {
        self.ref?.removeValue()
    }
}
