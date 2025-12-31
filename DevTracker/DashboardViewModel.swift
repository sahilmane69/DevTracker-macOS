import SwiftUI
import Combine


class DashboardViewModel: ObservableObject {
    @Published var stats: DailyStats = .empty
    @Published var githubToken: String = ""
    @Published var activeProjectName: String = ""

    init() {
        refresh()
    }

    func refresh() {
        stats = DataManager.shared.loadStats()
        activeProjectName = stats.activeProject
    }

    func saveToken() {
        DataManager.shared.saveGitHubToken(githubToken)
        refresh()
    }

    func saveProject() {
        DataManager.shared.saveActiveProject(activeProjectName)
        refresh()
    }

    func manualRefresh() {
        refresh()
    }
}
