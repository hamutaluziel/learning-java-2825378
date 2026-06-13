import SwiftUI

struct FoodLogSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: AppSettings
    let onSave: (FoodEntry) -> Void

    @State private var mealType = FoodEntry.MealType.lunch
    @State private var description = ""
    @State private var isAnalyzing = false
    @State private var analysisResult: FoodAnalysisResult?
    @State private var errorMessage: String?

    var canAnalyze: Bool { !description.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section(L.mealType) {
                    Picker(L.mealType, selection: $mealType) {
                        ForEach(FoodEntry.MealType.allCases, id: \.self) { type in
                            Label(type.localizedName, systemImage: type.icon).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }

                Section(L.whatDidYouEat) {
                    TextEditor(text: $description)
                        .frame(minHeight: 80)
                        .overlay(
                            Group {
                                if description.isEmpty {
                                    Text(L.foodDescription)
                                        .font(.caption).foregroundStyle(.tertiary)
                                        .padding(.vertical, 8).padding(.horizontal, 4)
                                }
                            },
                            alignment: .topLeading
                        )
                }

                if let result = analysisResult {
                    Section(L.aiFeedback) {
                        MacroResultRow(result: result)
                        Text(result.feedback)
                            .font(.subheadline)
                        if !result.suggestions.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Label(L.suggestions, systemImage: "lightbulb.fill")
                                    .font(.caption).foregroundStyle(.orange)
                                Text(result.suggestions).font(.caption)
                            }
                        }
                    }
                }

                if let err = errorMessage {
                    Section {
                        Text(err).foregroundStyle(.red).font(.caption)
                    }
                }

                Section {
                    Button {
                        Task { await analyze() }
                    } label: {
                        HStack {
                            Spacer()
                            if isAnalyzing {
                                ProgressView()
                                Text(L.analyzing).foregroundStyle(.secondary)
                            } else {
                                Label(L.analyzeFood, systemImage: "sparkles")
                            }
                            Spacer()
                        }
                    }
                    .disabled(!canAnalyze || isAnalyzing)
                }
            }
            .navigationTitle(L.logFood)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L.cancel) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L.save) { save() }
                        .fontWeight(.semibold)
                        .disabled(description.isEmpty)
                }
            }
        }
    }

    private func analyze() async {
        guard !settings.profile.claudeAPIKey.isEmpty else {
            errorMessage = L.noAPIKey
            return
        }
        isAnalyzing = true
        errorMessage = nil
        do {
            analysisResult = try await ClaudeAPIService.shared.analyzeFoodLog(
                mealDescription: description,
                mealType: mealType.localizedName,
                userProfile: settings.profile,
                previousMeals: []
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isAnalyzing = false
    }

    private func save() {
        let entry = FoodEntry(
            mealType: mealType,
            description: description,
            estimatedCalories: analysisResult?.estimatedCalories ?? 0,
            estimatedProteinG: analysisResult?.estimatedProteinG ?? 0,
            estimatedCarbsG: analysisResult?.estimatedCarbsG ?? 0,
            estimatedFatG: analysisResult?.estimatedFatG ?? 0,
            aiFeedback: [analysisResult?.feedback, analysisResult?.suggestions]
                .compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: "\n\n")
        )
        onSave(entry)
        dismiss()
    }
}

struct MacroResultRow: View {
    let result: FoodAnalysisResult

    var body: some View {
        HStack {
            StarsView(count: result.stars)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(result.estimatedCalories) kcal")
                    .font(.system(.callout, design: .rounded, weight: .bold)).foregroundStyle(.orange)
                HStack(spacing: 6) {
                    Text("P:\(Int(result.estimatedProteinG))g")
                    Text("C:\(Int(result.estimatedCarbsG))g")
                    Text("F:\(Int(result.estimatedFatG))g")
                }
                .font(.caption2).foregroundStyle(.secondary)
            }
        }
    }
}

struct StarsView: View {
    let count: Int
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= count ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundStyle(i <= count ? .yellow : .gray)
            }
        }
    }
}
