//
//  AsyncImageView.swift
//  DessertsApp
//
//  Created by siva on 1/9/24.
//

import Foundation

import SwiftUI

struct AsyncImageView: View {
    @State var data: Data?
    @State var isLoading: Bool = true
    var urlString: String

    var body: some View {
        Group {
            if isLoading {
                ZStack {
                    Color.gray
                    ProgressView()
                }
            } else if let data = data, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image(systemName: "photo") // Fallback for errors or invalid data
            }
        }
        .onAppear {
            fetchData()
        }
    }

    func fetchData() {
        guard let url = URL(string: urlString) else {
            isLoading = false
            return // Handle invalid URL
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    self.data = data
                }
                isLoading = false
            }
        }
        task.resume()
    }
}
