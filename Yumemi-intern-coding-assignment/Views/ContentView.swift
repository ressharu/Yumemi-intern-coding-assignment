//
//  ContentView.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/17.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var input: PersonalRecord = PersonalRecord() // ユーザー入力の個人情報を保持する状態
    @State private var selectedBloodType: BloodType = .a // 血液型の選択状態
    @State private var birthday: Birthday = Birthday() // ユーザーの誕生日情報を保持する状態
    @State private var responseMessage: FortuneResponse = FortuneResponse() // サーバーからの応答メッセージを保持する状態
    @State private var showingDetail = false // 詳細ビューを表示するかどうかの状態
    @State private var isLoading = false // ローディング中かどうかの状態
    @State private var errorMessage: String? = nil // エラーメッセージを保持する状態

    @Environment(\.modelContext) private var context

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
                    APIService.shared.sendInfo(input: input, birthday: birthday, selectedBloodType: selectedBloodType) { result in
                        DispatchQueue.main.async {
                            isLoading = false
                            switch result {
                            case .success(let message):
                                self.responseMessage = message // 成功時の応答メッセージを設定
                                self.showingDetail = true // 詳細ビューを表示
                                DataService.shared.savePersonalRecord(input: input, birthday: birthday, selectedBloodType: selectedBloodType, responseMessage: responseMessage, context: context)
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
}

#Preview {
    ContentView()
}
