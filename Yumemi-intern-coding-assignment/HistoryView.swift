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
    @Query(sort: \PersonalRecordHistory.today, order: .reverse) private var personalRecords: [PersonalRecordHistory]
    @Query(sort: \FortuneResponseHistory.name) private var fortuneResponses: [FortuneResponseHistory]
    
    @State private var selectedRecord: FortuneResponseHistory?
    @State private var showingDetail = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("占い履歴！")
                    .font(.title)
                    .padding()

                List {
                    Section(header: Text("Fortune Responses")) {
                        ForEach(fortuneResponses) { response in
                            VStack(alignment: .leading) {
                                HStack {
                                    if let url = URL(string: response.logo_url.absoluteString) {
                                        WebImage(url: url)
                                            .onSuccess { image, data, cacheType in }
                                            .resizable()
                                            .indicator(.activity)
                                            .frame(width: 100, height: 100)
                                            .scaledToFit()
                                    }
                                    
                                    Divider()
                                    
                                    VStack(alignment: .leading) {
                                        Text(response.name)
                                            .font(.headline)
                                        Text("Capital: \(response.capital)")
                                        Text("Has Coast Line: \(response.has_coast_line ? "Yes" : "No")")
                                        Text("Citizen Day: \(response.CitizenDay_month)/\(response.CitizenDay_day)")
                                        Text(response.brief)
                                            .lineLimit(3)
                                    }
                                }
                            }
                            .listRowSeparator(.visible)
                            .onTapGesture {
                                selectedRecord = response
                                showingDetail = true
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationDestination(isPresented: $showingDetail) {
                if let record = selectedRecord {
                    DetailView(personalRecord: personalRecords.first { $0.id == record.id }, fortune: record)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
