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
    @State private var responseMessage: FortuneResponse = FortuneResponse() // サーバーからの応答メッセージを保持する状態
    @State private var showingDetail = false // 詳細ビューを表示するかどうかの状態
    @State private var isLoading = false // ローディング中かどうかの状態
    @State private var errorMessage: String? = nil // エラーメッセージを保持する状態
    
    @State private var selectedDate: Date = Date()
    
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
                                    .foregroundColor(Color.primary)
                            }
                            Section(header: Text("お誕生日")) {
                                DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                                    .datePickerStyle(.wheel)
                                    .padding(.horizontal)
                                    .foregroundColor(Color.primary)
                            }
                            .onChange(of: selectedDate) {
                                let calendar = Calendar.current
                                let components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
                                input.birthday.year = components.year ?? 0
                                input.birthday.month = components.month ?? 0
                                input.birthday.day = components.day ?? 0
                            }
                            
                            Section(header: Text("血液型")) {
                                Picker("血液型", selection: $input.bloodType) { // 血液型選択ピッカー
                                    ForEach(PersonalRecord.BloodType.allCases) { bloodType in
                                        Text(bloodType.displayName + "型").tag(bloodType)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal)
                                .foregroundColor(Color.primary)
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
                    APIService.shared.sendInfo(input: input) { result in
                        DispatchQueue.main.async {
                            isLoading = false
                            switch result {
                            case .success(let message):
                                self.responseMessage = message // 成功時の応答メッセージを設定
                                self.showingDetail = true // 詳細ビューを表示
                                DataService.shared.savePersonalRecord(input: input, responseMessage: responseMessage, context: context)
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
                .navigationDestination(isPresented: $showingDetail) {
                    FortuneView(fortune: responseMessage) // 応答メッセージを表示するビュー
                }
            }
        }
    }
}
