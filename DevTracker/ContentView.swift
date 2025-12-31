import SwiftUI

struct ContentView: View {
    @StateObject var vm = DashboardViewModel()
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("DevTracker")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                    Button(action: { vm.manualRefresh() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { showSettings.toggle() }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showSettings) {
                        SettingsView(vm: vm)
                            .frame(width: 300, height: 200)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                HStack(spacing: 16) {
                    StatsCard(
                        title: "Coding Time",
                        value: formatTime(vm.stats.totalCodingTime),
                        icon: "clock.fill",
                        color: .blue
                    )
                    
                    StatsCard(
                        title: "Active Project",
                        value: vm.stats.activeProject,
                        icon: "hammer.fill",
                        color: .orange
                    )
                }
                .frame(height: 120)
                .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Breakdown")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        ForEach(vm.stats.breakdown.sorted(by: { $0.value > $1.value }).prefix(4), id: \.key) { key, value in
                            HStack {
                                Text(key)
                                    .font(.subheadline)
                                Spacer()
                                Text(formatTimeShort(value))
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding()
                    .background(Material.ultraThin)
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("GitHub")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Image(systemName: "git.commit")
                        }
                        
                        if let commit = vm.stats.lastCommit {
                            Text(commit.repoName)
                                .font(.subheadline)
                                .bold()
                            Text(commit.message)
                                .font(.caption)
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                            Text(timeAgo(commit.date))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        } else {
                            Text("No recent commits found")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Material.ultraThin)
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return String(format: "%dh %02dm", hours, minutes)
    }
    
    func formatTimeShort(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            return String(format: "%.1fh", time / 3600.0)
        }
    }
    
    func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct StatsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            Spacer()
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.5)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Material.ultraThin)
        .cornerRadius(16)
    }
}

struct SettingsView: View {
    @ObservedObject var vm: DashboardViewModel
    
    var body: some View {
        Form {
            Section(header: Text("GitHub Access")) {
                SecureField("Personal Access Token", text: $vm.githubToken)
                Button("Save Token", action: { vm.saveToken() })
            }
            
            Section(header: Text("Project")) {
                TextField("Active Project Name", text: $vm.activeProjectName)
                Button("Update Project", action: { vm.saveProject() })
            }
        }
        .padding()
    }
}
