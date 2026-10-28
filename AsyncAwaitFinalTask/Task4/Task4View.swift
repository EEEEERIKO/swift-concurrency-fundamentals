//
//  Task4View.swift
//  AsyncAwaitFinalTask
//
//  Created by Nikolay Dechko on 08/07/2024.
//
import SwiftUI

struct Task4View: View {
    
    var api = Task4ViewAPI()
    @State private var finished: Bool = false
    @State private var ballance: Int = 1000
    @State private var isRunning = false
    
    var body: some View {
        VStack {
            Text("Starting ballance: 1000")
            if finished {
                Text("Final balance: \(ballance)")
                Text(ballance == 0 ? "Success" : "Failure")
            }
            Button {
                if finished {
                    Task {
                        await api.reset()
                        ballance = 1000
                        finished = false
                    }
                } else  if !isRunning {
                    isRunning = true
                    
                    Task {
                        ballance = await api.startUpdate()
                        finished = true
                        isRunning = false
                    }
                }
            } label: {
                if finished {
                    Text("Reset")
                } else if isRunning {
                    Text("Running...")
                } else {
                    Text("Start")
                }
            }
            .disabled(isRunning)
        }
    }
}

#Preview {
    Task4View()
}

actor Task4ViewAPI {
    private var ballance: Int = 1000
    
    func decrementBalance() {
        ballance -= 1
    }
    
    func startUpdate() async -> Int {
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<1000 {
                group.addTask {
                    await self.decrementBalance()
                }
            }
        }
        return ballance
    }
    
    func reset() {
        ballance = 1000
    }
}
