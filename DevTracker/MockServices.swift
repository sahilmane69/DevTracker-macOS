import Foundation


class DataManager {
    static let shared = DataManager()

    func loadStats() -> DailyStats {
        DailyStats(
            totalCodingTime: 2 * 3600 + 25 * 60,
            activeProject: "DevTracker",
            breakdown: [
                "WebStorm": 5400,
                "Terminal": 1800,
                "Browser": 900
            ],
            lastCommit: Commit(
                repoName: "devtracker",
                message: "Initial UI layout",
                date: Date().addingTimeInterval(-3600)
            )
        )
    }

    func getGitHubToken() -> String? { nil }
    func saveGitHubToken(_ token: String) {}
    func saveActiveProject(_ name: String) {}
}


class GitHubService {
    static let shared = GitHubService()
    func fetchLatestActivity() async {}
}
//
//  MockServices.swift
//  DevTracker
//
//  Created by Sahil Mane on 31/12/25.
//

