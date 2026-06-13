import SwiftUI
import SwiftData

struct NutritionView: View {
    @EnvironmentObject var settings: AppSettings
    @Environment(\.modelContext) var context
    @Query(sort: \FoodEntry.date, order: .reverse) var allEntries: [FoodEntry]
    @State private var showLogSheet = false
    @State private var dailyInsight: String = ""
    @State private var isLoadingInsight = false

    var todayEntries: [FoodEntry] {
        let today = Calendar.current.startOfDay(for: .now)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        return allEntries.filter { $0.date >= today && $0.date < tomorrow }
    }

    var todaySummary: DailyNutritionSummary {
        DailyNutritionSummary(date: .now, entries: todayEntries)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    macroSummaryCard
                    if todayEntries.isEmpty {
                        emptyState
                    } else {
                        mealsList
                        insightCard
                    }
                }
                .padding()
            }
            .navigationTitle(L.nutrition)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showLogSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3).foregroundStyle(.orange)
                    }
                }
            }
            .sheet(isPresented: $showLogSheet) {
                FoodLogSheet(onSave: { entry in
                    context.insert(entry)
                })
            }
        }
    }

    private var macroSummaryCard: some View {
        let profile = settings.profile
        return VStack(spacing: 14) {
            Text(L.todaysSummary).font(.headline)

            HStack(spacing: 0) {
                MacroCell(
                    label: L.calories,
                    value: todaySummary.totalCalories,
                    target: profile.goalCalories,
                    unit: "kcal",
                    color: .orange
                )
                Divider()
                MacroCell(
                    label: L.protein,
                    value: Int(todaySummary.totalProtein),
                    target: Int(profile.dailyProteinTarget),
                    unit: "g",
                    color: .red
                )
                Divider()
                MacroCell(
                    label: L.carbs,
                    value: Int(todaySummary.totalCarbs),
                    target: Int(profile.dailyCarbTarget),
                    unit: "g",
                    color: .yellow
                )
                Divider()
                MacroCell(
                    label: L.fat,
                    value: Int(todaySummary.totalFat),
                    target: Int(profile.dailyFatTarget),
                    unit: "g",
                    color: .green
                )
            }
            .frame(height: 70)

            CalorieProgressBar(
                current: todaySummary.totalCalories,
                target: profile.goalCalories
            )
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4)
    }

    private var mealsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ארוחות היום").font(.headline)
            ForEach(todayEntries) { entry in
                FoodEntryCard(entry: entry, onDelete: {
                    context.delete(entry)
                })
            }
        }
    }

    private var insightCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(L.dailyInsight).font(.headline)
                Spacer()
                Button {
                    Task { await loadDailyInsight() }
                } label: {
                    if isLoadingInsight {
                        ProgressView().scaleEffect(0.8)
                    } else {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.orange)
                    }
                }
            }
            if dailyInsight.isEmpty {
                Text("לחצי על ✨ לקבלת תובנה יומית מה-AI")
                    .font(.caption).foregroundStyle(.secondary)
            } else {
                Text(dailyInsight)
                    .font(.subheadline).foregroundStyle(.primary)
            }
        }
        .padding()
        .background(.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60)).foregroundStyle(.orange.opacity(0.5))
            Text(L.noFoodToday)
                .font(.subheadline).foregroundStyle(.secondary)
            Button {
                showLogSheet = true
            } label: {
                Label(L.logFood, systemImage: "plus")
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent).tint(.orange)
        }
        .padding(40)
    }

    private func loadDailyInsight() async {
        isLoadingInsight = true
        defer { isLoadingInsight = false }
        do {
            dailyInsight = try await ClaudeAPIService.shared.generateDailyInsight(
                summary: todaySummary,
                profile: settings.profile
            )
        } catch {
            dailyInsight = error.localizedDescription
        }
    }
}

struct MacroCell: View {
    let label: String
    let value: Int
    let target: Int
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 3) {
            Text(label).font(.caption2).foregroundStyle(.secondary)
            Text("\(value)").font(.system(.callout, design: .rounded, weight: .bold)).foregroundStyle(color)
            Text("/\(target)\(unit)").font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CalorieProgressBar: View {
    let current: Int
    let target: Int

    var progress: Double { min(Double(current) / Double(target), 1.0) }
    var color: Color {
        progress < 0.7 ? .green : progress < 0.95 ? .orange : .red
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6).fill(.gray.opacity(0.15)).frame(height: 10)
                    RoundedRectangle(cornerRadius: 6).fill(color.gradient)
                        .frame(width: geo.size.width * progress, height: 10)
                }
            }
            .frame(height: 10)
            Text("\(current) / \(target) kcal · \(Int(progress * 100))%")
                .font(.caption2).foregroundStyle(.secondary)
        }
    }
}

struct FoodEntryCard: View {
    let entry: FoodEntry
    let onDelete: () -> Void
    @State private var showDetail = false

    var mealIcon: String {
        FoodEntry.MealType(rawValue: entry.mealType)?.icon ?? "fork.knife"
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: mealIcon)
                .foregroundStyle(.orange)
                .frame(width: 36, height: 36)
                .background(.orange.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.description)
                    .font(.subheadline).fontWeight(.medium)
                    .lineLimit(1)
                HStack(spacing: 8) {
                    Text("\(entry.estimatedCalories) kcal")
                    Text("·")
                    Text("\(Int(entry.estimatedProteinG))g חלבון")
                }
                .font(.caption).foregroundStyle(.secondary)
                if !entry.aiFeedback.isEmpty {
                    Text(starString(entry.aiFeedback))
                        .font(.caption2).foregroundStyle(.orange)
                }
            }

            Spacer()

            Button {
                showDetail = true
            } label: {
                Image(systemName: "chevron.right")
                    .font(.caption).foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.04), radius: 3)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onDelete) {
                Label(L.delete, systemImage: "trash")
            }
        }
        .sheet(isPresented: $showDetail) { FoodDetailSheet(entry: entry) }
    }

    private func starString(_ feedback: String) -> String {
        feedback.isEmpty ? "" : "★ AI analyzed"
    }
}

struct FoodDetailSheet: View {
    let entry: FoodEntry
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(entry.description).font(.headline)
                            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))

                    Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 8) {
                        GridRow {
                            NutrientBadge(label: L.calories, value: "\(entry.estimatedCalories)", unit: "kcal", color: .orange)
                            NutrientBadge(label: L.protein, value: "\(Int(entry.estimatedProteinG))", unit: "g", color: .red)
                        }
                        GridRow {
                            NutrientBadge(label: L.carbs, value: "\(Int(entry.estimatedCarbsG))", unit: "g", color: .yellow)
                            NutrientBadge(label: L.fat, value: "\(Int(entry.estimatedFatG))", unit: "g", color: .green)
                        }
                    }
                    .padding(.horizontal)

                    if !entry.aiFeedback.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label(L.aiFeedback, systemImage: "sparkles")
                                .font(.headline).foregroundStyle(.orange)
                            Text(entry.aiFeedback)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(.orange.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button(L.done) { dismiss() } } }
        }
    }
}

struct NutrientBadge: View {
    let label: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(label).font(.caption2).foregroundStyle(.secondary)
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value).font(.system(.title3, design: .rounded, weight: .bold)).foregroundStyle(color)
                Text(unit).font(.caption).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
    }
}
