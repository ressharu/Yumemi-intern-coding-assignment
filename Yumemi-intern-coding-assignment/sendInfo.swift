//
//  sendInfo.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/18.
//

import Foundation

func sendInfo(input: PersonalRecord, birthday: Birthday, selectedBloodType: BloodType) {
    var updatedInput = input
    updatedInput.birthday.year = Int(birthday.year) ?? 0
    updatedInput.birthday.month = Int(birthday.month) ?? 0
    updatedInput.birthday.day = Int(birthday.day) ?? 0
    updatedInput.blood_type = selectedBloodType.displayName.lowercased()
    
    // URLとリクエストの設定
    let url = URL(string: "https://ios-junior-engineer-codecheck-snefnyqv2q-an.a.run.app/my_fortune")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("v1", forHTTPHeaderField: "API-Version")
    
    // リクエストボディの設定
    let body: [String: Any] = [
        "name": updatedInput.name,
        "birthday": [
            "year": updatedInput.birthday.year,
            "month": updatedInput.birthday.month,
            "day": updatedInput.birthday.day
        ],
        "blood_type": updatedInput.blood_type,
        "today": [
            "year": Calendar.current.component(.year, from: Date()),
            "month": Calendar.current.component(.month, from: Date()),
            "day": Calendar.current.component(.day, from: Date())
        ]
    ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch {
        print("Error serializing JSON: \(error)")
        return
    }
    
    // リクエスト送信
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response")
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Failed with status code: \(httpResponse.statusCode)")
            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("Response body: \(responseBody)")
            }
            return
        }
        
        if let data = data {
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Success!")
                    print(jsonResponse)
                }
            } catch {
                print("Error parsing response JSON: \(error)")
            }
        }
    }
    
    task.resume()
}
