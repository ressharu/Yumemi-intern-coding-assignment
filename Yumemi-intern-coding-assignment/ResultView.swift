//
//  ResultView.swift
//  Yumemi-intern-coding-assignment
//
//  Created by 渡邉華輝 on 2024/06/20.
//

import SwiftUI

struct AsyncImageView: View {
    @State private var image: UIImage? = nil
    let url: URL

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}

struct FortuneView: View {
    var fortune: FortuneResponse

    var body: some View {
        VStack {
            Text("都道府県: \(fortune.name)")
            Text("県庁所在地: \(fortune.capital)")
            Text("説明: \(fortune.brief)")
            if let citizenDay = fortune.citizen_day {
                Text("県民の日: \(citizenDay.month)/\(citizenDay.day)")
            }
            Text("海と面している？: \(fortune.has_coast_line ? "Yes" : "No")")
            
            AsyncImageView(url: fortune.logo_url)
        }
        .navigationBarTitle("Fortune Result", displayMode: .inline)
    }
}

#Preview {
    FortuneView(fortune: FortuneResponse(
        name: "富山県",
        capital: "富山市",
        citizen_day: FortuneResponse.CitizenDay(month: 5, day: 9),
        has_coast_line: true,
        logo_url: URL(string: "https://japan-map.com/wp-content/uploads/toyama.png")!,
        brief: "富山県（とやまけん）は、日本の中部地方に位置する県。県庁所在地は富山市。\n中部地方の日本海側、新潟県を含めた場合の北陸地方のほぼ中央にある。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』"
    ))
}
