//
//  FortuneResultHistory.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/22.
//

import Foundation
import SwiftData

@Model
final class FortuneResponseHistory {
    var id: Int
    var name: String
    var capital: String
    var has_coast_line: Bool
    var logo_url: URL
    var brief: String
    var CitizenDay_month: Int
    var CitizenDay_day: Int
    
    init(id: Int, name: String, capital: String, has_coast_line: Bool, logo_url: URL, brief: String, CitizenDay_month: Int, CitizenDay_day: Int) {
        self.id = id
        self.name = name
        self.capital = capital
        self.has_coast_line = has_coast_line
        self.logo_url = logo_url
        self.brief = brief
        self.CitizenDay_month = CitizenDay_month
        self.CitizenDay_day = CitizenDay_day
    }
}
