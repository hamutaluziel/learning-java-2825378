import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var healthKit: HealthKitService
    @EnvironmentObject var settings: AppSettings
    @State private var showHealthAlert = false

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12: return L.goodMorning
        case 12..<17: return L.goodAfternoon
        default: return L.goodEvening
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    greetingCard
                    if !healthKit.isAuthorized {
                        healthPermissionCard
                    } else {
                        activityRingsRow
                        weeklyChart
                        recentWorkoutCard
                    }
                }
                .padding()
            }
            .navigationTitle("FitLife 💪")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await healthKit.fetchAllData()
            }
        }
        .onAppear {
            if !healthKit.isAuthorized {
                Task { await healthKit.requestAuthorization() }
            }
        }
    }

    private var greetingCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.title2).fontWeight(.semibold)
                let bmi = String(format: "%.1f", settings.profile.bmi)
                Text("BMI \(bmi) · \(settings.profile.bmiCategory)")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int(settings.profile.weightKg)) ק\"ג")
                    .font(.title3).fontWeight(.bold).foregroundStyle(.orange)
                Text("ירדת 29 ק\"ג 🎉")
                    .font(.caption2).foregroundStyle(.green)
            }
        }
        .padding()
        .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
    }

    private var healthPermissionCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.system(size: 40))
                .foregroundStyle(.red)
            Text(L.connectHealth)
                .font(.headline)
            Text(L.healthPermissionNeeded)
                .font(.caption).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Button(L.connectHealthApp) {
                Task { await healthKit.requestAuthorization() }
            }
            .buttonStyle(.borderedProminent).tint(.red)
        }
        .padding(24)
        .background(.red.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
    }

    private var activityRingsRow: some View {
        let summary = healthKit.todaySummary
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(icon: "figure.walk", value: "\(summary.steps.formatted())", label: L.steps, color: .green)
            StatCard(icon: "road.lanes", value: String(format: "%.1f ק\"מ", summary.distanceKm), label: L.distance, color: .blue)
            StatCard(icon: "flame.fill", value: "\(Int(summary.activeCalories))", label: L.activeCalories, color: .orange)
        }
    }

    private var weeklyChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L.weeklyProgress)
                .font(.headline).padding(.horizontal, 4)
            Chart(healthKit.weeklyStats, id: \.date) { day in
                BarMark(
                    x: .value("Day", day.date, unit: .day),
                    y: .value(L.steps, day.steps)
                )
                .foregroundStyle(.orange.gradient)
                .cornerRadius(4)
            }
            .frame(height: 120)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                }
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4)
    }

    private var recentWorkoutCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L.recentWorkouts)
                .font(.headline)
            if let last = healthKit.recentWorkouts.first {
                WorkoutRowView(workout: last)
            } else {
                Text(L.noWorkouts).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)
            Text(value)
                .font(.system(.callout, design: .rounded, weight: .bold))
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}
