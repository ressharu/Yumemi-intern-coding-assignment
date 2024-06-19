//
//  ContentView.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/17.
//

import SwiftUI

struct ContentView: View {
    @State private var input: PersonalRecord = PersonalRecord()
    @State private var selectedBloodType: BloodType = .a
    @State private var birthday: Birthday = Birthday()

    var body: some View {
        VStack {
            Form {
                Section(header: Text("情報を入力")) {
                    TextField("名前", text: $input.name)
                
                    TextField("年", text: $birthday.year)
                    TextField("月", text: $birthday.month)
                    TextField("日", text: $birthday.day)
                    Picker("血液型", selection: $selectedBloodType) {
                        ForEach(BloodType.allCases) { bloodType in
                            Text(bloodType.displayName + "型")
                        }
                    }
                }
            }
            //Text("選択された血液型: \(selectedBloodType.displayName)")
            Button(action: {
                sendInfo(input: input, birthday: birthday, selectedBloodType: selectedBloodType)
            }) {
                Text("送信する")
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
