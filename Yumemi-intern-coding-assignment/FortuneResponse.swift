//
//  FortuneResponse.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/19.
//

import Foundation

struct FortuneResponse: Codable, Hashable {
    var name: String
    var capital: String
    var citizen_day: CitizenDay?
    var has_coast_line: Bool
    var logo_url: URL
    var brief: String

    struct CitizenDay: Codable, Hashable {
        var month: Int
        var day: Int
    }

    // イニシャライザ
    init(name: String = "", capital: String = "", citizen_day: CitizenDay? = nil, has_coast_line: Bool = true, logo_url: URL = URL(string: "https://example.com")!, brief: String = "") {
        self.name = name
        self.capital = capital
        self.citizen_day = citizen_day
        self.has_coast_line = has_coast_line
        self.logo_url = logo_url
        self.brief = brief
    }
}
