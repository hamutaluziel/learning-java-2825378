import Foundation
import SwiftData

@Model
final class FoodEntry {
    var id: UUID
    var date: Date
    var mealType: String
    var description: String
    var estimatedCalories: Int
    var estimatedProteinG: Double
    var estimatedCarbsG: Double
    var estimatedFatG: Double
    var aiFeedback: String
    var feedbackGeneratedAt: Date?

    init(
        date: Date = .now,
        mealType: MealType = .lunch,
        description: String,
        estimatedCalories: Int = 0,
        estimatedProteinG: Double = 0,
        estimatedCarbsG: Double = 0,
        estimatedFatG: Double = 0,
        aiFeedback: String = ""
    ) {
        self.id = UUID()
        self.date = date
        self.mealType = mealType.rawValue
        self.description = description
        self.estimatedCalories = estimatedCalories
        self.estimatedProteinG = estimatedProteinG
        self.estimatedCarbsG = estimatedCarbsG
        self.estimatedFatG = estimatedFatG
        self.aiFeedback = aiFeedback
    }

    enum MealType: String, CaseIterable {
        case breakfast = "breakfast"
        case lunch = "lunch"
        case dinner = "dinner"
        case snack = "snack"

        var localizedName: String {
            switch self {
            case .breakfast: return L.breakfast
            case .lunch: return L.lunch
            case .dinner: return L.dinner
            case .snack: return L.snack
            }
        }

        var icon: String {
            switch self {
            case .breakfast: return "sunrise.fill"
            case .lunch: return "sun.max.fill"
            case .dinner: return "moon.fill"
            case .snack: return "leaf.fill"
            }
        }
    }
}

struct DailyNutritionSummary {
    let date: Date
    let entries: [FoodEntry]

    var totalCalories: Int { entries.reduce(0) { $0 + $1.estimatedCalories } }
    var totalProtein: Double { entries.reduce(0) { $0 + $1.estimatedProteinG } }
    var totalCarbs: Double { entries.reduce(0) { $0 + $1.estimatedCarbsG } }
    var totalFat: Double { entries.reduce(0) { $0 + $1.estimatedFatG } }
}
