//
//  DetailView.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    var personalRecord: PersonalRecordHistory?
    var fortune: FortuneResponseHistory
    
    var body: some View {
        ScrollView {
            VStack {
                if let record = personalRecord {
                    VStack {
                        Text("入力した情報") // 入力した情報の見出し
                            .font(.title2)
                            .padding(.bottom)
                            .bold()
                        HStack {
                            Text("お名前:") // 名前のラベル
                                .bold()
                            Text(record.name) // 名前の値
                        }
                        HStack {
                            Text("お誕生日:") // 誕生日のラベル
                                .bold()
                            Text("\(record.year)年 \(record.month)月 \(record.day)日") // 誕生日の値
                        }
                        HStack {
                            Text("血液型:") // 血液型のラベル
                                .bold()
                            Text(record.bloodType) // 血液型の値
                        }
                        HStack {
                            Text("占った日:") // 占いをした日のラベル
                                .bold()
                            Text(record.today) // 占いをした日の値
                        }
                    }
                    .padding()
                }
                
                Divider()
                    .padding(.vertical)
                
                // FortuneViewを使用して占い結果を表示
                FortuneView(fortune: FortuneResponse(
                    name: fortune.name,
                    capital: fortune.capital,
                    citizen_day: FortuneResponse.CitizenDay(month: fortune.CitizenDay_month, day: fortune.CitizenDay_day),
                    has_coast_line: fortune.has_coast_line,
                    logo_url: fortune.logo_url,
                    brief: fortune.brief
                ))
            }
            .navigationBarTitle("詳細ビュー", displayMode: .inline) // ナビゲーションバーのタイトルを設定
            .padding()
        }
    }
}
