//
//  RootView.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/17.
//

import SwiftUI

enum Tab {
    case popular
    case favorite
}

struct RootView: View {
    var body: some View {
        TabView {
            ContentView()
                .tag(Tab.popular)
                .tabItem {
                    Label(
                        title: { Text("ホーム") },
                        icon: { Image(systemName: "house.fill") }
                    )
                }
            HistoryView()
                .tag(Tab.favorite)
                .tabItem {
                    Label(
                        title: { Text("履歴") },
                        icon: { Image(systemName: "list.star") }
                    )
                }
        }
    }
}
