//
//  DataService.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/23.
//

import Foundation
import SwiftData

class DataService {
    static let shared = DataService()

    private init() {}

    func savePersonalRecord(input: PersonalRecord, birthday: Birthday, selectedBloodType: BloodType, responseMessage: FortuneResponse, context: ModelContext) {
        let id: Int = UUID().hashValue
        
        //PersonalRecordHistoryに保存
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        guard let year = today.year, let month = today.month, let day = today.day else {
            return
        }

        let personalRecordH = PersonalRecordHistory(
            id: id,
            name: input.name,
            year: Int(birthday.year) ?? 0,
            month: Int(birthday.month) ?? 0,
            day: Int(birthday.day) ?? 0,
            bloodType: selectedBloodType.displayName,
            today: "\(year)-\(month)-\(day)"
        )

        context.insert(personalRecordH)

        do {
            try context.save()
            print("Personal record saved successfully")
        } catch {
            print("Failed to save personal record: \(error.localizedDescription)")
        }
        
        //FortuneResponseHistoryに保存
        let fortuneResponseH = FortuneResponseHistory(
            id: id,
            name: responseMessage.name,
            capital: responseMessage.capital,
            has_coast_line: responseMessage.has_coast_line,
            logo_url: responseMessage.logo_url,
            brief: responseMessage.brief,
            CitizenDay_month: responseMessage.citizen_day?.month ?? 0,
            CitizenDay_day: responseMessage.citizen_day?.day ?? 0
        )

        context.insert(fortuneResponseH)

        do {
            try context.save()
            print("Fortune result saved successfully")
        } catch {
            print("Failed to save Fortune result: \(error.localizedDescription)")
        }
    }
}
