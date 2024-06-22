//
//  HistoryView.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/22.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI

struct HistoryView: View {
    @Query(sort: \PersonalRecordHistory.today, order: .reverse) private var personalRecords: [PersonalRecordHistory]
    @Query(sort: \FortuneResponseHistory.name) private var fortuneResponses: [FortuneResponseHistory]
    
    @State private var selectedRecord: FortuneResponseHistory?
    @State private var showingDetail = false
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("占い履歴！")
                    .font(.system(.title, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding()
                    .bold()
                    .padding(.bottom, 0)
                
                List {
                    Section {
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
                                        HStack {
                                            Text("県庁所在地:")
                                                .bold()
                                            Text(response.capital)
                                        }
                                        HStack {
                                            Text("海と面している？:")
                                                .bold()
                                            Text(response.has_coast_line ? "Yes" : "No")
                                        }
                                        HStack {
                                            Text("県民の日:")
                                                .bold()
                                            Text("\(response.CitizenDay_month)/\(response.CitizenDay_day)")
                                        }
                                        HStack {
                                            Text("県庁所在地:")
                                                .bold()
                                            Text(response.capital)
                                        }
                                        Text("\(response.brief)")
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
                        .onDelete(perform: deleteRecord)
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
    
    private func deleteRecord(at offsets: IndexSet) {
        for index in offsets {
            let response = fortuneResponses[index]
            if let personalRecord = personalRecords.first(where: { $0.id == response.id }) {
                context.delete(personalRecord)
            }
            context.delete(response)
        }
        
        do {
            try context.save()
            print("Record deleted successfully")
        } catch {
            print("Failed to delete record: \(error.localizedDescription)")
        }
    }
}
