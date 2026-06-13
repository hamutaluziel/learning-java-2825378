import Foundation
import HealthKit

struct WorkoutData: Identifiable {
    let id: UUID
    let type: HKWorkoutActivityType
    let startDate: Date
    let endDate: Date
    let durationMinutes: Double
    let distanceKm: Double?
    let energyBurnedKcal: Double?
    let averageHeartRate: Double?
    let source: String

    var duration: String {
        let minutes = Int(durationMinutes)
        return minutes >= 60
            ? "\(minutes / 60)ש' \(minutes % 60)ד'"
            : "\(minutes)ד'"
    }

    var activityName: String {
        switch type {
        case .running: return L.running
        case .walking: return L.walking
        case .cycling: return L.cycling
        case .swimming: return L.swimming
        case .functionalStrengthTraining: return L.strengthTraining
        case .traditionalStrengthTraining: return L.strengthTraining
        default: return L.workout
        }
    }

    var activityIcon: String {
        switch type {
        case .running: return "figure.run"
        case .walking: return "figure.walk"
        case .cycling: return "figure.outdoor.cycle"
        case .swimming: return "figure.pool.swim"
        case .functionalStrengthTraining, .traditionalStrengthTraining: return "figure.strengthtraining.traditional"
        default: return "figure.mixed.cardio"
        }
    }
}

struct DailyActivitySummary {
    let date: Date
    var steps: Int = 0
    var distanceKm: Double = 0
    var activeCalories: Double = 0
    var standHours: Int = 0
    var exerciseMinutes: Double = 0
    var workouts: [WorkoutData] = []
}
