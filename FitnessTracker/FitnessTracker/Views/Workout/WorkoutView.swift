import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var healthKit: HealthKitService
    @State private var selectedFilter: WorkoutFilter = .all
    @State private var showDetail: WorkoutData?

    enum WorkoutFilter: String, CaseIterable {
        case all, running, walking, strength
        var label: String {
            switch self {
            case .all: return L.workouts
            case .running: return L.running
            case .walking: return L.walking
            case .strength: return L.strengthTraining
            }
        }
    }

    var filteredWorkouts: [WorkoutData] {
        switch selectedFilter {
        case .all: return healthKit.recentWorkouts
        case .running: return healthKit.recentWorkouts.filter { $0.type == .running }
        case .walking: return healthKit.recentWorkouts.filter { $0.type == .walking }
        case .strength: return healthKit.recentWorkouts.filter {
            $0.type == .traditionalStrengthTraining || $0.type == .functionalStrengthTraining
        }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterPicker
                if healthKit.isLoading {
                    ProgressView().padding(40)
                } else if filteredWorkouts.isEmpty {
                    emptyState
                } else {
                    workoutList
                }
            }
            .navigationTitle(L.workouts)
            .refreshable { await healthKit.fetchAllData() }
        }
    }

    private var filterPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(WorkoutFilter.allCases, id: \.self) { filter in
                    Button(filter.label) {
                        selectedFilter = filter
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 14).padding(.vertical, 7)
                    .background(selectedFilter == filter ? Color.orange : Color.gray.opacity(0.15),
                                in: Capsule())
                    .foregroundStyle(selectedFilter == filter ? .white : .primary)
                }
            }
            .padding()
        }
    }

    private var workoutList: some View {
        List(filteredWorkouts) { workout in
            WorkoutRowView(workout: workout)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .onTapGesture { showDetail = workout }
        }
        .listStyle(.plain)
        .sheet(item: $showDetail) { WorkoutDetailSheet(workout: $0) }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            L.noWorkouts,
            systemImage: "figure.run.circle",
            description: Text("אימונים מ-Runna ואפליקציות אחרות יופיעו כאן לאחר סנכרון עם Apple Health")
        )
    }
}

struct WorkoutRowView: View {
    let workout: WorkoutData

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: workout.activityIcon)
                .font(.title2).foregroundStyle(.orange)
                .frame(width: 44, height: 44)
                .background(.orange.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(workout.activityName)
                    .font(.subheadline).fontWeight(.semibold)
                Text(workout.startDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 10) {
                    Label(workout.duration, systemImage: "clock")
                    if let km = workout.distanceKm {
                        Label(String(format: "%.2f ק\"מ", km), systemImage: "road.lanes")
                    }
                }
                .font(.caption2).foregroundStyle(.secondary)
            }

            Spacer()

            if let kcal = workout.energyBurnedKcal {
                VStack {
                    Text("\(Int(kcal))")
                        .font(.system(.callout, design: .rounded, weight: .bold))
                        .foregroundStyle(.orange)
                    Text("kcal").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
}

struct WorkoutDetailSheet: View {
    let workout: WorkoutData
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    DetailRow(label: L.duration, value: workout.duration)
                    if let km = workout.distanceKm {
                        DetailRow(label: L.distance, value: String(format: "%.2f ק\"מ", km))
                    }
                    if let kcal = workout.energyBurnedKcal {
                        DetailRow(label: L.calories, value: "\(Int(kcal)) kcal")
                    }
                    DetailRow(label: L.source, value: workout.source)
                    DetailRow(label: "תאריך", value: workout.startDate.formatted(date: .long, time: .shortened))
                }
            }
            .navigationTitle(workout.activityName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button(L.done) { dismiss() } } }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack { Text(label).foregroundStyle(.secondary); Spacer(); Text(value).fontWeight(.medium) }
    }
}
