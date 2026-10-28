//
//  Task3View.swift
//  AsyncAwaitFinalTask
//
//  Created by Nikolay Dechko on 05/07/2024.
//

import SwiftUI

struct Task3View: View {
    @State private var currentStrength: Task3API.SignalStrenght = .unknown
    @State private var running: Bool = false
    
    let api = Task3API()
    
    var body: some View {
        VStack {
            HStack {
                Text("Current signal strength: \(currentStrength)")
            }
            Button {
                if running {
                    running.toggle()
                    api.cancel()
                } else {
                    running.toggle()
                    Task {
                        let stream = api.signalStrength()
                        for await strength in stream {
                            currentStrength = strength
                        }
                        currentStrength = .unknown
                        print("stream finished")
                    }
                }
            } label: {
                if running {
                    Text("Cancel")
                } else {
                    Text("Start monitoring")
                }
            }

        }
    }
}

final class Task3API {
    enum SignalStrenght: String {
        case weak, strong, excellent, unknown
    }
    
    private var producerTask: Task<Void, Never>?
    private var continuation: AsyncStream<SignalStrenght>.Continuation?
    
    func signalStrength() -> AsyncStream<SignalStrenght> {
        
        cancel()
        return AsyncStream { continuation in
            self.continuation = continuation
            
            producerTask = Task {
                let possibleValues: [SignalStrenght] = [
                    .weak, .strong, .excellent]
                
                while !Task.isCancelled {
                    do {
                        try await Task.sleep(for: .seconds(1))
                    } catch {
                        break
                    }
                    
                    guard !Task.isCancelled else { break }
                    
                    let strength = possibleValues.randomElement() ?? .unknown
                    continuation.yield(strength)
                }
                continuation.finish()
                
            }
        }
    }
    
    func cancel() {
        producerTask?.cancel()
        producerTask = nil
        
        continuation?.finish()
        continuation = nil
    }
}

#Preview {
    Task3View()
}
