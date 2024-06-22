//
//  PersonalRecord.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/18.
//

import Foundation

struct PersonalRecord: Decodable, Encodable {
    var name: String
    var birthday: YearMonthDay
    var blood_type: String
    var today: String
    
    struct YearMonthDay: Decodable, Encodable {
        var year: Int
        var month: Int
        var day: Int
    }
    
    // イニシャライザ
    init(name: String = "", year: Int = 0, month: Int = 0, day: Int = 0, blood_type: String = "", today: String = "") {
        self.name = name
        self.birthday = YearMonthDay(year: year, month: month, day: day)
        self.blood_type = blood_type
        self.today = today
    }
    
    // CodingKeys: JSONのキーとプロパティのマッピングを定義
    private enum CodingKeys: String, CodingKey {
        case name
        case birthday
        case blood_type
        case today
    }
}

struct Birthday {
    var year: String
    var month: String
    var day: String
    
    init(year: String = "", month: String = "", day: String = "") {
        self.year = year
        self.month = month
        self.day = day
    }
}

enum BloodType: String, CaseIterable, Identifiable {
    case a
    case b
    case ab
    case o
    
    var displayName: String {
        switch self {
        case .a: return "A"
        case .b: return "B"
        case .ab: return "AB"
        case .o: return "O"
        }
    }
    
    var id: Self {
        self
    }
}
