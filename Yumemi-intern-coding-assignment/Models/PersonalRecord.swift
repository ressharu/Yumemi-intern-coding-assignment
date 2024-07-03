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
    var bloodType: BloodType
    var today: YearMonthDay
    
    struct YearMonthDay: Decodable, Encodable {
        var year: Int
        var month: Int
        var day: Int
    }
    
    enum BloodType: String, CaseIterable, Identifiable, Codable {
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
    
    // イニシャライザ
    init(name: String = "", year: Int = 0, month: Int = 0, day: Int = 0, bloodType: BloodType = .a) {
        self.name = name
        self.birthday = YearMonthDay(year: year, month: month, day: day)
        self.bloodType = bloodType
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        self.today = YearMonthDay(year: components.year ?? 0, month: components.month ?? 0, day: components.day ?? 0)
    }
    
    // CodingKeys: JSONのキーとプロパティのマッピングを定義
    private enum CodingKeys: String, CodingKey {
        case name
        case birthday
        case bloodType = "blood_type"
        case today
    }
}
