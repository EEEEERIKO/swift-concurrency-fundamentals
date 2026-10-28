# Swift Concurrency Fundamentals

A hands-on Swift concurrency project based on EPAM's Async/Await training exercises. It explores asynchronous programming, structured concurrency, asynchronous streams, cancellation, and actor-based state isolation.

## Overview

This project contains four practical exercises designed to understand how Swift handles asynchronous operations and concurrent tasks.

## Exercises

### Task 1 — Async/Await

**Objective:** Rewrite a callback-based API implementation using `async/await`.

- Replace completion handlers with an asynchronous function.
- Use `URLSession` to perform an asynchronous network request.
- Handle errors using `throws` and `do/catch`.
- Update the SwiftUI interface with the result.

**Note:** The original Numbers API endpoint returned `404 Not Found` during testing, including when tested independently through Postman. Therefore, successful retrieval of a live number fact could not be verified.

### Task 2 — Task Groups

**Objective:** Execute two asynchronous operations concurrently using a task group.

- Fetch user information and product data in parallel.
- Collect results from child tasks.
- Measure total execution time using `TimeInterval`.
- Display the results in a SwiftUI view.

The sample API simulates each request with a one-second delay, allowing sequential and concurrent execution times to be compared.

### Task 3 — AsyncStream and Cancellation

**Objective:** Produce a continuous stream of asynchronous values and stop it on demand.

- Emit a random signal-strength value every second.
- Consume values using `for await`.
- Cancel the producer task.
- Finish the stream and restore the initial state.

Signal-strength values include `weak`, `strong`, `excellent`, and `unknown`.

### Task 4 — Actors and Race Conditions

**Objective:** Prevent race conditions when multiple concurrent tasks modify shared state.

- Launch 1,000 child tasks using `withTaskGroup`.
- Protect the shared balance using a Swift `actor`.
- Synchronize balance decrements through actor isolation.
- Verify that the final balance consistently reaches zero.
- Reset the balance to repeat the exercise.

## Tech Stack

- Swift
- SwiftUI
- Structured Concurrency
- `async/await`
- `withThrowingTaskGroup` and `withTaskGroup`
- `AsyncStream`
- `Task` cancellation
- Actors and actor isolation
- `URLSession`

## Requirements

- Xcode with support for Swift concurrency and SwiftUI.
- An iOS Simulator or compatible Apple device.

## Getting Started

1. Clone or download this repository.
2. Open the `.xcodeproj` file in Xcode.
3. Select an iOS Simulator or compatible device.
4. Build and run the application.
5. Select an exercise from the main screen and follow its instructions.

## Learning Outcomes

After completing these exercises, you should understand how to:

- Replace callback-based networking code with `async/await`.
- Execute independent asynchronous operations concurrently.
- Consume and finish asynchronous streams.
- Manage task cancellation.
- Protect mutable shared state using actors.
- Measure and reason about concurrent execution time.

## Acknowledgements

Based on the Async/Await training exercises provided by EPAM.

This repository is intended for educational purposes.
