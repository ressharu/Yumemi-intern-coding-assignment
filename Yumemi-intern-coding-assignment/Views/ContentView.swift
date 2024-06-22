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
                ScrollView {
                    VStack {
                        Text("あなたと相性のいい\n都道府県を占ってあげる！") // タイトル
                            .font(.system(.title, design: .rounded))
                            .multilineTextAlignment(.center)
                            .bold()
                            .padding()
                        
                        Image("FortuneImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                        
                        Text("あなたのことを教えて！")
                            .font(.system(.title, design: .rounded))
                            .multilineTextAlignment(.center)
                            .bold()
                            .padding()
                        
                        VStack {
                            Section(header: Text("お名前")) {
                                TextField("お名前", text: $input.name) // 名前入力フィールド
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                            }
                            Section(header: Text("お誕生日")) {
                                TextField("年 例: 2000", text: $birthday.year) // 年入力フィールド
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                                TextField("月 例: 4", text: $birthday.month) // 月入力フィールド
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                                TextField("日 例: 1", text: $birthday.day) // 日入力フィールド
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                            }
                            Section(header: Text("血液型")) {
                                Picker("血液型", selection: $selectedBloodType) { // 血液型選択ピッカー
                                    ForEach(BloodType.allCases) { bloodType in
                                        Text(bloodType.displayName + "型")
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                }
                
                if let errorMessage = errorMessage { // エラーメッセージの表示
                    Text(errorMessage)
                        .foregroundColor(.red)
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
                            case .failure(_):
                                self.errorMessage = "エラーが発生しました。もう一度やり直してください。" // エラーメッセージを設定
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
