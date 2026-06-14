import Foundation

// Uses Google Gemini API (free tier, no credit card required)
// Get a free key at: aistudio.google.com
class ClaudeAPIService {
    static let shared = ClaudeAPIService()
    private let model = "gemini-1.5-flash"

    private func endpoint(for apiKey: String) -> String {
        "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)"
    }

    func analyzeFoodLog(
        mealDescription: String,
        mealType: String,
        userProfile: UserProfile,
        previousMeals: [FoodEntry]
    ) async throws -> FoodAnalysisResult {
        let apiKey = userProfile.claudeAPIKey
        guard !apiKey.isEmpty else { throw ClaudeError.noAPIKey }

        let lang = userProfile.language == .hebrew ? "Hebrew" : "English"
        let previousMealsSummary = buildPreviousMealsSummary(previousMeals, language: lang)

        let fullPrompt = """
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

        I just ate (\(mealType)): \(mealDescription)

        Please:
        1. Estimate the nutritional values (calories, protein, carbs, fat)
        2. Give me feedback on this meal in context of my daily goals
        3. Suggest 1-2 specific improvements or additions for the rest of the day
        4. Rate this meal 1-5 stars for nutritional quality

        Respond ONLY with a JSON object, no extra text:
        {
          "estimatedCalories": number,
          "estimatedProteinG": number,
          "estimatedCarbsG": number,
          "estimatedFatG": number,
          "stars": number,
          "feedback": "warm feedback text",
          "suggestions": "specific suggestions"
        }
        """

        let text = try await callGemini(prompt: fullPrompt, apiKey: apiKey)
        return try parseAnalysisResult(from: text)
    }

    func generateDailyInsight(summary: DailyNutritionSummary, profile: UserProfile) async throws -> String {
        let apiKey = profile.claudeAPIKey
        guard !apiKey.isEmpty else { throw ClaudeError.noAPIKey }

        let lang = profile.language == .hebrew ? "Hebrew" : "English"
        let prompt = """
        I'm a \(profile.age)+ woman, \(profile.weightKg)kg who walks 7-10km daily.
        Today I ate a total of \(summary.totalCalories) calories, \(Int(summary.totalProtein))g protein,
        \(Int(summary.totalCarbs))g carbs, \(Int(summary.totalFat))g fat.
        My goal is \(profile.goalCalories) cal, \(Int(profile.dailyProteinTarget))g protein.

        Give me a brief end-of-day nutrition recap with encouragement and one tip for tomorrow.
        Respond in \(lang) only. Keep it under 150 words.
        """

        return try await callGemini(prompt: prompt, apiKey: apiKey)
    }

    private func callGemini(prompt: String, apiKey: String) async throws -> String {
        let body: [String: Any] = [
            "contents": [["parts": [["text": prompt]]]],
            "generationConfig": ["temperature": 0.7, "maxOutputTokens": 1024]
        ]

        var request = URLRequest(url: URL(string: endpoint(for: apiKey))!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 30

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else { throw ClaudeError.networkError }
        guard httpResponse.statusCode == 200 else {
            if let errorResp = try? JSONDecoder().decode(GeminiErrorResponse.self, from: data) {
                throw ClaudeError.apiError(errorResp.error.message)
            }
            throw ClaudeError.networkError
        }

        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        return geminiResponse.candidates.first?.content.parts.first?.text ?? ""
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

private struct GeminiResponse: Codable {
    let candidates: [Candidate]
    struct Candidate: Codable {
        let content: Content
    }
    struct Content: Codable {
        let parts: [Part]
    }
    struct Part: Codable {
        let text: String
    }
}

private struct GeminiErrorResponse: Codable {
    let error: ErrorDetail
    struct ErrorDetail: Codable {
        let message: String
    }
}
