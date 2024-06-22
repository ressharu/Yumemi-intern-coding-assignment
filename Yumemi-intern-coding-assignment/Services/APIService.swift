//
//  APIService.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/23.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func sendInfo(input: PersonalRecord, birthday: Birthday, selectedBloodType: BloodType, completion: @escaping (Result<FortuneResponse, Error>) -> Void) {
        var updatedInput = input
        
        // 誕生日情報を更新
        updatedInput.birthday.year = Int(birthday.year) ?? 0
        updatedInput.birthday.month = Int(birthday.month) ?? 0
        updatedInput.birthday.day = Int(birthday.day) ?? 0
        updatedInput.blood_type = selectedBloodType.displayName.lowercased()
        
        let url = URL(string: "https://ios-junior-engineer-codecheck-snefnyqv2q-an.a.run.app/my_fortune")! // リクエストURL
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // HTTPメソッドをPOSTに設定
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // ヘッダーにコンテンツタイプを設定
        request.addValue("v1", forHTTPHeaderField: "API-Version") // ヘッダーにAPIバージョンを設定
        
        // リクエストボディを作成
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
        
        // JSONシリアライズを試行
        do {
            print("Request Body: \(body)") // デバッグ用にボディを出力
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("JSON Serialization Error: \(error.localizedDescription)") // エラーを出力
            completion(.failure(error)) // シリアライズエラーを返す
            return
        }
        
        // データタスクを作成して実行
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error)) // リクエストエラーを返す
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data else {
                let responseError = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                completion(.failure(responseError)) // ステータスコードエラーを返す
                return
            }
            
            do {
                // デバッグ用に生のJSONレスポンスを印刷
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("JSON Response: \(jsonResponse)")
                
                let decodedResponse = try JSONDecoder().decode(FortuneResponse.self, from: data) // JSONレスポンスをデコード
                completion(.success(decodedResponse)) // 成功結果を返す
            } catch {
                completion(.failure(error)) // デコードエラーを返す
            }
        }
        
        task.resume() // タスクを開始
    }
}
