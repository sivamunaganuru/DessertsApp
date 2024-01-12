//
//  DessertData.swift
//  DessertsApp
//
//  Created by siva on 1/9/24.
//

import Foundation
import SwiftUI

// Defines the structure for dessert data, conforming to the Decodable protocol for JSON decoding
// and Identifiable protocol for use in SwiftUI Lists.
struct DessertData: Decodable, Identifiable {
    // Computed property to conform to Identifiable protocol, using the meal's ID
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
}

// Extensions can add additional functionality to existing types.
extension DessertData {
    // Provides mock data for use in previews or testing.
    static let MockData  = DessertData(
        idMeal: "53049",
        strMeal: "Apam balik",
        strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"
    )
    // An array of mock data items for use in previews or testing.
    static let MockArray = [MockData, MockData, MockData, MockData]
}

// Represents the expected structure of the API response.
struct APIResponse: Decodable {
    let meals: [DessertData]
}

// IdentifiableError holds an error message and conforms to Identifiable so it can be used
// with SwiftUI's alert system.
struct IdentifiableError: Identifiable {
    let id = UUID() // Conform to Identifiable
    let message: String
}

// Provides a mock error for testing the display of error messages.
extension IdentifiableError {
    static let MockError = IdentifiableError (
        message : "Testing error alert"
    )
}

// The ObservableObject protocol allows instances of this class to be used within SwiftUI's
// data flow.
class DessertDataService: ObservableObject {
    // Published properties will trigger view updates when their values change.
    @Published var desserts: [DessertData] = []
    @Published var error: IdentifiableError? // To hold the error message
    @Published var isLoading = false

    // fetchDesserts() will contact the API to retrieve dessert data.
    func fetchDesserts() {
        isLoading = true
        // Guard statement to ensure the URL is valid, setting an error and stopping if not.
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            self.error = IdentifiableError(message: "Invalid URL")
            isLoading = false
            return
        }
        
        // Initiating a network call to the provided URL.
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            // Handling errors by updating the error property on the main thread.
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message:"Error fetching data: \(error.localizedDescription)")
                }
                return
            }
            
            // Additional guard statements to handle unexpected responses or lack of data.
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message: "Error response from server: \(String(describing: response))")
                }
                return
            }
            
            guard let mimeType = httpResponse.mimeType, mimeType == "application/json" else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message: "Invalid MIME type: \(String(describing: httpResponse.mimeType))")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message: "No data received")
                }
                return
            }
            
            // Attempting to decode the JSON data into our DessertData model.
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                let sortedDesserts = decodedResponse.meals.filter { !$0.strMeal.isEmpty && !$0.strMealThumb.isEmpty }.sorted { $0.strMeal < $1.strMeal }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.desserts = sortedDesserts
                    self.error = nil // Clear error message upon successful fetch
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = IdentifiableError(message: "Failed to decode JSON: \(error.localizedDescription)")
                }
            }
        }.resume() // Starts the network call task.
    }
}
