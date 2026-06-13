import Foundation

struct UserProfile: Codable {
    var weightKg: Double = 80.0
    var heightCm: Double = 168.0
    var age: Int = 46
    var gender: Gender = .female
    var goalCalories: Int = 2100
    var claudeAPIKey: String = ""
    var language: AppLanguage = .hebrew
    var calisthenicsWeek: Int = 1
    var calisthenicsDay: Int = 1

    enum Gender: String, Codable, CaseIterable {
        case female = "female"
        case male = "male"

        var localizedName: String {
            switch self {
            case .female: return L.female
            case .male: return L.male
            }
        }
    }

    enum AppLanguage: String, Codable, CaseIterable {
        case hebrew = "he"
        case english = "en"

        var localizedName: String {
            switch self {
            case .hebrew: return "עברית"
            case .english: return "English"
            }
        }
    }

    var bmr: Double {
        // Mifflin-St Jeor equation for women
        return (10 * weightKg) + (6.25 * heightCm) - (5.0 * Double(age)) - 161
    }

    var tdee: Double {
        // Very active (daily 7-10km)
        return bmr * 1.725
    }

    var bmi: Double {
        let heightM = heightCm / 100
        return weightKg / (heightM * heightM)
    }

    var bmiCategory: String {
        switch bmi {
        case ..<18.5: return L.underweight
        case 18.5..<25: return L.normalWeight
        case 25..<30: return L.overweight
        default: return L.obese
        }
    }

    var dailyProteinTarget: Double { weightKg * 1.8 }
    var dailyCarbTarget: Double { Double(goalCalories) * 0.40 / 4.0 }
    var dailyFatTarget: Double { Double(goalCalories) * 0.30 / 9.0 }
}
