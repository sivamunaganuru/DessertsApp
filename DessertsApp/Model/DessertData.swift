//
//  DessertData.swift
//  DessertsApp
//
//  Created by siva on 1/9/24.
//

import Foundation
import SwiftUI

struct DessertData: Decodable, Identifiable {
    var id: String { idMeal } // Computed property to conform to Identifiable
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
}

struct APIResponse: Decodable {
    let meals: [DessertData]
}

struct IdentifiableError: Identifiable {
    let id = UUID() // Conform to Identifiable
    let message: String
}


struct MockData {
    static let sampleDessertData = DessertData(
        idMeal: "53049",
        strMeal: "Apam balik",
        strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"
    )
    static let DessertArray = [sampleDessertData,sampleDessertData,sampleDessertData,sampleDessertData]
}



class DessertDataService: ObservableObject {
    @Published var desserts: [DessertData] = []
    @Published var error: IdentifiableError? // To hold the error message

    func fetchDesserts() {
        print("started fetching items")
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            self.error = IdentifiableError(message: "Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            // Check for errors, unwrap data
            if let error = error {
                DispatchQueue.main.async {
                    self.error = IdentifiableError(message:"Error fetching data: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.error = IdentifiableError(message: "Error response from server: \(String(describing: response))")
                }
                return
            }
            
            guard let mimeType = httpResponse.mimeType, mimeType == "application/json" else {
                DispatchQueue.main.async {
                    self.error = IdentifiableError(message: "Invalid MIME type: \(String(describing: httpResponse.mimeType))")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.error = IdentifiableError(message: "No data received")
                }
                return
            }
            
            do {
                // Decode the data
                let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                // Sort and filter out empty or null values
                let sortedDesserts = decodedResponse.meals.filter { !$0.strMeal.isEmpty && !$0.strMealThumb.isEmpty }.sorted { $0.strMeal < $1.strMeal }
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.desserts = sortedDesserts
                    self.error = nil // Clear error message upon successful fetch
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = IdentifiableError(message: "Failed to decode JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
