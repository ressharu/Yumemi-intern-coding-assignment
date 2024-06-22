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
        VStack {
            Text("\(fortune.name)")
                .font(.system(.largeTitle, design: .serif))
                .multilineTextAlignment(.center)
                .bold()
                .padding(.top)
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
                        }
                        Text("概要:")
                            .bold()
                        Text(fortune.brief)
                            .multilineTextAlignment(.center)
                        HStack {
                            Text("県民の日:")
                                .bold()
                            if let citizenDay = fortune.citizen_day {
                                Text("\(citizenDay.month)/\(citizenDay.day)")
                            } else {
                                Text("なし")
                            }
                        }
                        HStack {
                            Text("海と面している？:")
                                .bold()
                            Text(fortune.has_coast_line ? "Yes" : "No")
                        }
                    }
                    Spacer()
                        .frame(width: 50.0)
                }
            }
        }
        .navigationBarTitle("占い結果！", displayMode: .inline)
    }
}
