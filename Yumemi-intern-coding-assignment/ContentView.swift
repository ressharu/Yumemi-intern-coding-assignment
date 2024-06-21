//
//  ContentView.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/17.
//

import SwiftUI

struct ContentView: View {
    @State private var input: PersonalRecord = PersonalRecord() // ユーザー入力の個人情報を保持する状態
    @State private var selectedBloodType: BloodType = .a // 血液型の選択状態
    @State private var birthday: Birthday = Birthday() // ユーザーの誕生日情報を保持する状態
    @State private var responseMessage: FortuneResponse // サーバーからの応答メッセージを保持する状態
    @State private var showingDetail = false // 詳細ビューを表示するかどうかの状態
    @State private var isLoading = false // ローディング中かどうかの状態
    @State private var errorMessage: String? = nil // エラーメッセージを保持する状態

    // イニシャライザにデフォルト値を設定
    init(responseMessage: FortuneResponse = FortuneResponse()) {
        self._responseMessage = State(initialValue: responseMessage)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("情報を入力")) {
                        TextField("名前", text: $input.name) // 名前入力フィールド
                        TextField("年", text: $birthday.year) // 年入力フィールド
                        TextField("月", text: $birthday.month) // 月入力フィールド
                        TextField("日", text: $birthday.day) // 日入力フィールド
                        Picker("血液型", selection: $selectedBloodType) { // 血液型選択ピッカー
                            ForEach(BloodType.allCases) { bloodType in
                                Text(bloodType.displayName + "型")
                            }
                        }
                    }
                }
                if let errorMessage = errorMessage { // エラーメッセージの表示
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                Button(action: { // ボタンアクション
                    isLoading = true
                    errorMessage = nil
                    sendInfo(input: input, birthday: birthday, selectedBloodType: selectedBloodType) { result in
                        DispatchQueue.main.async {
                            isLoading = false
                            switch result {
                            case .success(let message):
                                self.responseMessage = message // 成功時の応答メッセージを設定
                                self.showingDetail = true // 詳細ビューを表示
                            case .failure(let error):
                                self.errorMessage = "Error: \(error.localizedDescription)" // エラーメッセージを設定
                            }
                        }
                    }
                }) {
                    if isLoading { // ローディング中の表示
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    } else { // ボタンの通常表示
                        Text("送信する")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                NavigationLink(
                    destination: FortuneView(fortune: responseMessage), // 応答メッセージを表示するビュー
                    isActive: $showingDetail
                ) {
                    EmptyView() // 詳細ビューへのナビゲーションリンク
                }
            }
        }
    }
    
    private func sendInfo(input: PersonalRecord, birthday: Birthday, selectedBloodType: BloodType, completion: @escaping (Result<FortuneResponse, Error>) -> Void) {
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
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
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

#Preview {
    ContentView()
}
