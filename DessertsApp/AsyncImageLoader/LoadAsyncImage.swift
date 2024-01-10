//
//  LoadAsyncImage.swift
//  DessertsApp
//
//  Created by siva on 1/9/24.
//

import SwiftUI

import SwiftUI

struct LoadAsyncImage: View {
    var imageUrl: String

    var body: some View {
        if #available(iOS 15, *) {
            Group {
                if let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                            case .empty:
                                ZStack {
                                    Color.gray
                                    ProgressView()
                                }
                            case .success(let image):
                                image.resizable()
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo") // Fallback for invalid URL
                }
            }
        } else {
            // Fallback on earlier versions
            AsyncImageView(urlString: imageUrl)
        }
    }
}

#Preview {
    LoadAsyncImage(imageUrl: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        .frame(width: 250, height: 250)
        .mask(RoundedRectangle(cornerRadius: 16))
}
