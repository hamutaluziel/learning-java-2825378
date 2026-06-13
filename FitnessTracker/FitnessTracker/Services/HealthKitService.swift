import Foundation
import HealthKit
import Combine

@MainActor
class HealthKitService: ObservableObject {
    static let shared = HealthKitService()
    private let store = HKHealthStore()

    @Published var isAuthorized = false
    @Published var todaySummary = DailyActivitySummary(date: .now)
    @Published var recentWorkouts: [WorkoutData] = []
    @Published var weeklyStats: [DailyActivitySummary] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let readTypes: Set<HKObjectType> = [
        HKObjectType.workoutType(),
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .bodyMass)!,
        HKObjectType.categoryType(forIdentifier: .appleStandHour)!,
        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
    ]

    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = L.healthNotAvailable
            return
        }
        do {
            try await store.requestAuthorization(toShare: [], read: readTypes)
            isAuthorized = true
            await fetchAllData()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchAllData() async {
        isLoading = true
        defer { isLoading = false }
        async let summary = fetchTodaySummary()
        async let workouts = fetchRecentWorkouts(days: 30)
        async let weekly = fetchWeeklyStats()
        todaySummary = await summary
        recentWorkouts = await workouts
        weeklyStats = await weekly
    }

    private func fetchTodaySummary() async -> DailyActivitySummary {
        let today = Calendar.current.startOfDay(for: .now)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let predicate = HKQuery.predicateForSamples(withStart: today, end: tomorrow)

        var summary = DailyActivitySummary(date: today)
        summary.steps = await fetchQuantity(.stepCount, predicate: predicate, unit: .count())
        summary.distanceKm = await fetchQuantityDouble(.distanceWalkingRunning, predicate: predicate, unit: .meterUnit(with: .kilo))
        summary.activeCalories = await fetchQuantityDouble(.activeEnergyBurned, predicate: predicate, unit: .kilocalorie())
        summary.exerciseMinutes = await fetchQuantityDouble(.appleExerciseTime, predicate: predicate, unit: .minute())
        summary.workouts = await fetchRecentWorkouts(days: 1)
        return summary
    }

    private func fetchQuantity(_ identifier: HKQuantityTypeIdentifier, predicate: NSPredicate, unit: HKUnit) async -> Int {
        Int(await fetchQuantityDouble(identifier, predicate: predicate, unit: unit))
    }

    private func fetchQuantityDouble(_ identifier: HKQuantityTypeIdentifier, predicate: NSPredicate, unit: HKUnit) async -> Double {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return 0 }
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, stats, _ in
                continuation.resume(returning: stats?.sumQuantity()?.doubleValue(for: unit) ?? 0)
            }
            store.execute(query)
        }
    }

    func fetchRecentWorkouts(days: Int) async -> [WorkoutData] {
        let start = Calendar.current.date(byAdding: .day, value: -days, to: .now)!
        let predicate = HKQuery.predicateForSamples(withStart: start, end: .now)
        let sortDesc = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: .workoutType(),
                predicate: predicate,
                limit: 100,
                sortDescriptors: [sortDesc]
            ) { _, samples, _ in
                let workouts = (samples as? [HKWorkout] ?? []).map { w in
                    WorkoutData(
                        id: w.uuid,
                        type: w.workoutActivityType,
                        startDate: w.startDate,
                        endDate: w.endDate,
                        durationMinutes: w.duration / 60,
                        distanceKm: w.totalDistance?.doubleValue(for: .meterUnit(with: .kilo)),
                        energyBurnedKcal: w.totalEnergyBurned?.doubleValue(for: .kilocalorie()),
                        averageHeartRate: nil,
                        source: w.sourceRevision.source.name
                    )
                }
                continuation.resume(returning: workouts)
            }
            store.execute(query)
        }
    }

    private func fetchWeeklyStats() async -> [DailyActivitySummary] {
        var stats: [DailyActivitySummary] = []
        for i in 0..<7 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Calendar.current.startOfDay(for: .now))!
            let end = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            let predicate = HKQuery.predicateForSamples(withStart: date, end: end)
            var day = DailyActivitySummary(date: date)
            day.steps = await fetchQuantity(.stepCount, predicate: predicate, unit: .count())
            day.distanceKm = await fetchQuantityDouble(.distanceWalkingRunning, predicate: predicate, unit: .meterUnit(with: .kilo))
            day.activeCalories = await fetchQuantityDouble(.activeEnergyBurned, predicate: predicate, unit: .kilocalorie())
            stats.append(day)
        }
        return stats.reversed()
    }

    func fetchLatestWeight() async -> Double? {
        guard let type = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return nil }
        return await withCheckedContinuation { continuation in
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
                let weight = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: .gramUnit(with: .kilo))
                continuation.resume(returning: weight)
            }
            store.execute(query)
        }
    }
}
