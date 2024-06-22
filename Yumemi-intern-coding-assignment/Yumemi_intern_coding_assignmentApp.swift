//
//  Yumemi_intern_coding_assignmentApp.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/17.
//

import SwiftUI
import SwiftData

@main
struct Yumemi_intern_coding_assignmentApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: [PersonalRecordHistory.self, FortuneResponseHistory.self], inMemory: false)
        }
    }
}
