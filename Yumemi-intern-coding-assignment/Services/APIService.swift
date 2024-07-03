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
    
    func sendInfo(input: PersonalRecord, completion: @escaping (Result<FortuneResponse, Error>) -> Void) {
        let updatedInput = input
        
        let url = URL(string: "https://ios-junior-engineer-codecheck-snefnyqv2q-an.a.run.app/my_fortune")! // リクエストURL
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // HTTPメソッドをPOSTに設定
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // ヘッダーにコンテンツタイプを設定
        request.addValue("v1", forHTTPHeaderField: "API-Version") // ヘッダーにAPIバージョンを設定
        
        // JSONエンコーダーを作成
        let encoder = JSONEncoder()
        
        // inputをJSONにシリアライズを試行
        do {
            let jsonData = try encoder.encode(updatedInput)
            print("Request Body: \(String(data: jsonData, encoding: .utf8) ?? "")") // デバッグ用にボディを出力
            request.httpBody = jsonData
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
                let decodedResponse = try JSONDecoder().decode(FortuneResponse.self, from: data) // JSONレスポンスをデコード
                completion(.success(decodedResponse)) // 成功結果を返す
            } catch {
                completion(.failure(error)) // デコードエラーを返す
            }
        }
        
        task.resume() // タスクを開始
    }
}
