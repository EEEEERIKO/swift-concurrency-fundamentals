//
//  Task2View.swift
//  AsyncAwaitFinalTask
//
//  Created by Nikolay Dechko on 4/9/24.
//

import SwiftUI

struct Task2View: View {
    let task2API: Task2API = .init()

    @State private var user: Task2API.User?
    @State private var products: [Task2API.Product] = []
    @State private var duration: TimeInterval?

    var body: some View {
        VStack {
            if let user, !products.isEmpty, let duration {
                Text("User name: \(user.name)").padding()
                List(products) { product in
                    Text("product description: \(product.description)")
                }
                Text("it took: \(duration) second(s)")
            } else {
                Text("Loading in progress")
            }
        }.task {
            do {
                let startDate = Date.now
                let result = try await withThrowingTaskGroup(
                    of: Task2Result.self
                ) {
                    group in group.addTask {
                        let user = try await task2API.getUser()
                        return .user(user)
                    }
                    
                    group.addTask {
                        let products = try await task2API.getProducts()
                        return .products(products)
                    }
                    
                    var fetchedUser: Task2API.User?
                    var fetchedProducts: [Task2API.Product] = []
                    
                    
                    for try await result in group {
                        switch result {
                        case .user(let user):
                            fetchedUser = user
                            
                        case .products(let products):
                            fetchedProducts = products
                        }
                    }
                    
                    guard let fetchedUser else {
                        throw URLError(.badServerResponse)
                    }
                    
                    return (user: fetchedUser, products: fetchedProducts)
                }
                
                user = try await task2API.getUser()
                products = try await task2API.getProducts()
                let endDate = Date.now

                duration = DateInterval(start: startDate, end: endDate).duration
            } catch {
                print("unexpected error")
            }
        }
    }
}


private enum Task2Result: Sendable {
    case user(Task2API.User)
    case products([Task2API.Product])
}

class Task2API: @unchecked Sendable {
    struct User {
        let name: String
    }

    struct Product: Identifiable, Sendable {
        let id: String
        let description: String
    }

    func getUser() async throws -> User {
        try await Task.sleep(for: .seconds(1))
        return .init(name: "John Smith")
    }

    func getProducts() async throws -> [Product] {
        try await Task.sleep(for: .seconds(1))
        return [.init(id: "1", description: "Some cool product"),
                .init(id: "2", description: "Some expensive product")]
    }
}

#Preview {
    Task2View()
}
