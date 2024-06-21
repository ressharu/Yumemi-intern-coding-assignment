//
//  FortuneView.swift
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
                    .frame(width: 300, height: 300)
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
            Text("\(fortune.name)")
                .font(.system(.largeTitle, design: .serif))
                .multilineTextAlignment(.center)
                .bold()
                .padding(.top)
            AsyncImageView(url: fortune.logo_url)
                .padding()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
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
