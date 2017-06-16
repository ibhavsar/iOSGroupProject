//
//  TodoItem.swift
//  iOSGroupProject
//
//  Created by Student on 2017-06-07.
//  Copyright © 2017 Ishan Student. All rights reserved.
//


import Foundation

struct TodoItem {
    var title: String
    var deadline: Date
    var UUID: String
    
    init(deadline: Date, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return (Date().compare(self.deadline) == ComparisonResult.orderedDescending) // deadline is earlier than current date
    }
}
