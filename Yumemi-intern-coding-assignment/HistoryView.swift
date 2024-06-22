//
//  HistoryView.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/22.
//

import Foundation
import SwiftUI
import SwiftData
import SDWebImageSwiftUI

struct HistoryView: View {
    // @Queryプロパティラッパーを使用して、データベースからPersonalRecordHistoryのレコードを取得
    @Query(sort: \PersonalRecordHistory.today, order: .reverse) private var personalRecords: [PersonalRecordHistory]
    // @Queryプロパティラッパーを使用して、データベースからFortuneResponseHistoryのレコードを取得
    @Query(sort: \FortuneResponseHistory.name) private var fortuneResponses: [FortuneResponseHistory]

    var body: some View {
        NavigationStack {
            VStack {
                // タイトルの表示
                Text("占い履歴！")
                    .font(.title)
                    .padding()

                // リストビューの表示
                List {
                    /*
                    // Personal Recordsセクション
                    Section(header: Text("Personal Records")) {
                        // personalRecordsの各レコードを表示
                        ForEach(personalRecords) { record in
                            VStack(alignment: .leading) {
                                Text(record.name) // 名前の表示
                                    .font(.headline)
                                Text("Birthday: \(record.year)-\(record.month)-\(record.day)") // 誕生日の表示
                                Text("Blood Type: \(record.bloodType)") // 血液型の表示
                                Text("Saved on: \(record.today)") // 保存日付の表示
                            }
                        }
                    }
                     
                    */

                    // Fortune Responsesセクション
                    Section(header: Text("Fortune Responses")) {
                        // fortuneResponsesの各レコードを表示
                        ForEach(fortuneResponses) { response in
                            VStack(alignment: .leading) {
                                HStack {
                                    // 画像の表示
                                    if let url = URL(string: response.logo_url.absoluteString) {
                                        WebImage(url: url)
                                            .onSuccess { image, data, cacheType in
                                                // 成功時の処理
                                            }
                                            .resizable()
                                            .indicator(.activity) // インジケータを表示
                                            .frame(width: 100, height: 100)
                                            .scaledToFit()
                                    }
                                    
                                    Divider() // 縦線の表示
                                    
                                    VStack(alignment: .leading) {
                                        Text(response.name) // 名前の表示
                                            .font(.headline)
                                        Text("Capital: \(response.capital)") // 首都の表示
                                        Text("Has Coast Line: \(response.has_coast_line ? "Yes" : "No")") // 海岸線の有無の表示
                                        Text("Citizen Day: \(response.CitizenDay_month)/\(response.CitizenDay_day)") // 県民の日の表示
                                        Text(response.brief) // 簡単な説明の表示
                                            .lineLimit(3)
                                    }
                                }
                            }
                            .listRowSeparator(.visible)
                        }
                    }
                }
                .listStyle(GroupedListStyle()) // グループ化されたリストスタイルを適用
            }
        }
    }
}

#Preview {
    HistoryView()
}
