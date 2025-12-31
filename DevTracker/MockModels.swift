import Foundation

// MARK: - Mock Commit
struct Commit {
    let repoName: String
    let message: String
    let date: Date
}

// MARK: - Daily Stats Model
struct DailyStats {
    var totalCodingTime: TimeInterval
    var activeProject: String
    var breakdown: [String: TimeInterval]
    var lastCommit: Commit?

    static let empty = DailyStats(
        totalCodingTime: 0,
        activeProject: "None",
        breakdown: [:],
        lastCommit: nil
    )
}
