//
//  FortuneView.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct FortuneView: View {
    var fortune: FortuneResponse
    
    var body: some View {
        ScrollView {
            VStack {
                Text("\(fortune.name)")
                    .font(.system(.largeTitle, design: .serif))
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(.top)
                    .foregroundColor(Color.primary)
                // 画像の表示
                if let url = URL(string: fortune.logo_url.absoluteString) {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                }
                Divider()
                    .frame(width: 300)
                ScrollView {
                    HStack {
                        Spacer()
                            .frame(width: 50.0)
                        VStack {
                            HStack {
                                Text("県庁所在地:")
                                    .bold()
                                Text(fortune.capital)
                                    .foregroundColor(Color.primary)
                            }
                            Text("概要:")
                                .bold()
                            Text(fortune.brief)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.primary)
                            HStack {
                                Text("県民の日:")
                                    .bold()
                                if let citizenDay = fortune.citizen_day {
                                    Text("\(citizenDay.month)/\(citizenDay.day)")
                                        .foregroundColor(Color.primary)
                                } else {
                                    Text("なし")
                                        .foregroundColor(Color.primary)
                                }
                            }
                            HStack {
                                Text("海と面している？:")
                                    .bold()
                                Text(fortune.has_coast_line ? "Yes" : "No")
                                    .foregroundColor(Color.primary)
                            }
                        }
                        Spacer()
                            .frame(width: 50.0)
                    }
                }
            }
        }
        .navigationBarTitle("占い結果！", displayMode: .inline)
    }
}
