//
//  SwiftUIView.swift
//  AsyncAwaitFinalTask
//
//  Created by Nikolay Dechko on 4/9/24.
//

import SwiftUI

struct Task1View: View, @unchecked Sendable {
    let task1API = Task1API()
    @State var fact = "To get random number fact press button below"
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            Text(fact)
                .padding()
            Button(action: {
                Task {
                    isLoading = true
                    defer { isLoading = false }
                    
                    do {
                        fact = try await task1API.getTrivia(for: nil)
                    } catch {
                        print("ERROR:", error)
                        print("DETAILS:", (error as NSError).userInfo)
                        fact = "Loading error: \(error.localizedDescription)"
                    }
                }
            }, label: { Text(isLoading ? "Loading..." : "Click me") })
        }
    }
}

#Preview {
    Task1View()
}

struct Task1API {
    private let baseURL = "http://numbersapi.com"
    private let triviaPath = "random/trivia"

    func getTrivia(for number: Int?) async throws -> String {
        let path = number.map { "\($0)/trivia" } ?? triviaPath

        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        guard let trivia = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }

        return trivia
    }
}
