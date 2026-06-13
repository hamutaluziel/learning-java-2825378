import Foundation

class ClaudeAPIService {
    static let shared = ClaudeAPIService()
    private let endpoint = "https://api.anthropic.com/v1/messages"
    private let model = "claude-sonnet-4-6"

    func analyzeFoodLog(
        mealDescription: String,
        mealType: String,
        userProfile: UserProfile,
        previousMeals: [FoodEntry]
    ) async throws -> FoodAnalysisResult {
        let apiKey = userProfile.claudeAPIKey
        guard !apiKey.isEmpty else {
            throw ClaudeError.noAPIKey
        }

        let lang = userProfile.language == .hebrew ? "Hebrew" : "English"
        let previousMealsSummary = buildPreviousMealsSummary(previousMeals, language: lang)

        let systemPrompt = """
        You are a certified nutritionist and fitness coach specializing in weight loss and muscle building.
        You are helping a \(userProfile.age)+ year old woman, \(userProfile.weightKg)kg, \(userProfile.heightCm)cm tall,
        who has already lost 29kg. She walks/runs 7-10km daily and is starting calisthenics training.

        Her daily targets:
        - Calories: \(userProfile.goalCalories) kcal
        - Protein: \(Int(userProfile.dailyProteinTarget))g (crucial for muscle development)
        - Carbs: \(Int(userProfile.dailyCarbTarget))g
        - Fat: \(Int(userProfile.dailyFatTarget))g

        TODAY'S MEALS SO FAR:
        \(previousMealsSummary.isEmpty ? "None yet" : previousMealsSummary)

        Respond ONLY in \(lang). Be warm, encouraging, and specific.
        """

        let userPrompt = """
        I just ate (\(mealType)): \(mealDescription)

        Please:
        1. Estimate the nutritional values (calories, protein, carbs, fat)
        2. Give me feedback on this meal in context of my daily goals
        3. Suggest 1-2 specific improvements or additions for the rest of the day
        4. Rate this meal 1-5 stars for nutritional quality

        Format your response as JSON with these fields:
        {
          "estimatedCalories": number,
          "estimatedProteinG": number,
          "estimatedCarbsG": number,
          "estimatedFatG": number,
          "stars": number (1-5),
          "feedback": "your warm feedback text here",
          "suggestions": "specific suggestions for rest of day"
        }
        """

        let body: [String: Any] = [
            "model": model,
            "max_tokens": 1024,
            "system": systemPrompt,
            "messages": [["role": "user", "content": userPrompt]]
        ]

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 30

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let errorData = try? JSONDecoder().decode(AnthropicError.self, from: data) {
                throw ClaudeError.apiError(errorData.error.message)
            }
            throw ClaudeError.networkError
        }

        let apiResponse = try JSONDecoder().decode(AnthropicResponse.self, from: data)
        let text = apiResponse.content.first?.text ?? ""

        return try parseAnalysisResult(from: text)
    }

    func generateDailyInsight(summary: DailyNutritionSummary, profile: UserProfile) async throws -> String {
        let apiKey = profile.claudeAPIKey
        guard !apiKey.isEmpty else { throw ClaudeError.noAPIKey }

        let lang = profile.language == .hebrew ? "Hebrew" : "English"
        let body: [String: Any] = [
            "model": model,
            "max_tokens": 512,
            "messages": [[
                "role": "user",
                "content": """
                I'm a \(profile.age)+ woman, \(profile.weightKg)kg who walks 7-10km daily.
                Today I ate a total of \(summary.totalCalories) calories, \(Int(summary.totalProtein))g protein,
                \(Int(summary.totalCarbs))g carbs, \(Int(summary.totalFat))g fat.
                My goal is \(profile.goalCalories) cal, \(Int(profile.dailyProteinTarget))g protein.

                Give me a brief end-of-day nutrition recap with encouragement and one tip for tomorrow.
                Respond in \(lang) only. Keep it under 150 words.
                """
            ]]
        ]

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 30

        let (data, _) = try await URLSession.shared.data(for: request)
        let apiResponse = try JSONDecoder().decode(AnthropicResponse.self, from: data)
        return apiResponse.content.first?.text ?? ""
    }

    private func buildPreviousMealsSummary(_ meals: [FoodEntry], language: String) -> String {
        meals.map { entry in
            "\(entry.mealType): \(entry.description) (\(entry.estimatedCalories)kcal, \(Int(entry.estimatedProteinG))g protein)"
        }.joined(separator: "\n")
    }

    private func parseAnalysisResult(from text: String) throws -> FoodAnalysisResult {
        let cleaned = text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = cleaned.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw ClaudeError.parseError
        }

        return FoodAnalysisResult(
            estimatedCalories: json["estimatedCalories"] as? Int ?? 0,
            estimatedProteinG: json["estimatedProteinG"] as? Double ?? 0,
            estimatedCarbsG: json["estimatedCarbsG"] as? Double ?? 0,
            estimatedFatG: json["estimatedFatG"] as? Double ?? 0,
            stars: json["stars"] as? Int ?? 3,
            feedback: json["feedback"] as? String ?? "",
            suggestions: json["suggestions"] as? String ?? ""
        )
    }
}

struct FoodAnalysisResult {
    let estimatedCalories: Int
    let estimatedProteinG: Double
    let estimatedCarbsG: Double
    let estimatedFatG: Double
    let stars: Int
    let feedback: String
    let suggestions: String
}

enum ClaudeError: LocalizedError {
    case noAPIKey
    case networkError
    case parseError
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .noAPIKey: return L.noAPIKey
        case .networkError: return L.networkError
        case .parseError: return L.parseError
        case .apiError(let msg): return msg
        }
    }
}

private struct AnthropicResponse: Codable {
    let content: [ContentBlock]
    struct ContentBlock: Codable {
        let text: String
    }
}

private struct AnthropicError: Codable {
    let error: ErrorDetail
    struct ErrorDetail: Codable {
        let message: String
    }
}
