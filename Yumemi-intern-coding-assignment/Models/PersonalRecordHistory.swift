//
//  PersonalRecordHistory.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/22.
//

import Foundation
import SwiftData

@Model
final class PersonalRecordHistory {
    var id: Int
    var name: String
    var year: Int
    var month: Int
    var day: Int
    var bloodType: String
    var today: String
    
    init(id: Int, name: String, year: Int, month: Int, day: Int, bloodType: String, today: String) {
        self.id = id
        self.name = name
        self.year = year
        self.month = month
        self.day = day
        self.bloodType = bloodType
        self.today = today
    }
}
