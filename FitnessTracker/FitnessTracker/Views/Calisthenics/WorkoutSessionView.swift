import SwiftUI
import SwiftData

struct WorkoutSessionView: View {
    let day: TrainingDay
    let onComplete: (CalisthenicsLog) -> Void

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State private var completedExercises: Set<UUID> = []
    @State private var currentIndex = 0
    @State private var showSummary = false
    @State private var difficulty = 3
    @State private var notes = ""
    @State private var startTime = Date.now
    @State private var restTimerActive = false
    @State private var restSecondsRemaining = 0
    @State private var restTimer: Timer?

    var allCompleted: Bool { completedExercises.count == day.exercises.count }
    var elapsedMinutes: Int { Int(Date.now.timeIntervalSince(startTime) / 60) }

    var body: some View {
        NavigationStack {
            if showSummary {
                summaryView
            } else {
                sessionView
            }
        }
    }

    private var sessionView: some View {
        VStack(spacing: 0) {
            progressHeader
            ScrollView {
                VStack(spacing: 12) {
                    if !day.warmupNote.isEmpty { warmupBanner }
                    exerciseList
                    if !day.cooldownNote.isEmpty && allCompleted { cooldownBanner }
                }
                .padding()
            }
            bottomBar
        }
        .navigationTitle(day.localizedTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(L.cancel) { dismiss() }
            }
        }
    }

    private var progressHeader: some View {
        VStack(spacing: 6) {
            ProgressView(value: Double(completedExercises.count) / Double(day.exercises.count))
                .tint(.orange)
                .padding(.horizontal)
            Text("\(completedExercises.count)/\(day.exercises.count) תרגילים הושלמו")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .background(.background)
    }

    private var warmupBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "flame").foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text(L.warmup).font(.caption).fontWeight(.semibold).foregroundStyle(.orange)
                Text(day.warmupNote).font(.caption2).foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }

    private var cooldownBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "snowflake").foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(L.cooldown).font(.caption).fontWeight(.semibold).foregroundStyle(.blue)
                Text(day.cooldownNote).font(.caption2).foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }

    private var exerciseList: some View {
        VStack(spacing: 10) {
            ForEach(Array(day.exercises.enumerated()), id: \.element.id) { idx, exercise in
                ExerciseCard(
                    exercise: exercise,
                    isCompleted: completedExercises.contains(exercise.id),
                    isCurrent: idx == currentIndex,
                    onComplete: {
                        withAnimation {
                            completedExercises.insert(exercise.id)
                            if idx == currentIndex && currentIndex < day.exercises.count - 1 {
                                startRestTimer(seconds: exercise.restSeconds)
                                currentIndex += 1
                            }
                        }
                    }
                )
            }
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 0) {
            if restTimerActive {
                RestTimerBanner(seconds: restSecondsRemaining, onSkip: { stopRestTimer() })
            }
            if allCompleted {
                Button {
                    withAnimation { showSummary = true }
                } label: {
                    Label(L.completeWorkout, systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent).tint(.green)
                .padding()
            }
        }
        .background(.background)
    }

    private var summaryView: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "trophy.fill")
                .font(.system(size: 80)).foregroundStyle(.orange)
            Text("כל הכבוד! 🎉")
                .font(.largeTitle).fontWeight(.bold)
            Text("השלמת את אימון \(day.localizedTitle)")
                .font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Text("⏱ \(elapsedMinutes) דקות").font(.title3).fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 8) {
                Text("דרג את האימון").font(.headline)
                HStack {
                    ForEach(1...5, id: \.self) { i in
                        Button { difficulty = i } label: {
                            Image(systemName: i <= difficulty ? "star.fill" : "star")
                                .font(.title2)
                                .foregroundStyle(i <= difficulty ? .orange : .gray)
                        }
                    }
                }
            }

            TextField(L.notes, text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3)
                .padding(.horizontal)

            Button {
                saveLog()
            } label: {
                Text("שמור ועבור לאימון הבא")
                    .frame(maxWidth: .infinity).fontWeight(.bold)
            }
            .buttonStyle(.borderedProminent).tint(.orange)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle("אימון הושלם!")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { Button(L.done) { dismiss() } } }
    }

    private func startRestTimer(seconds: Int) {
        restSecondsRemaining = seconds
        restTimerActive = true
        restTimer?.invalidate()
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if restSecondsRemaining > 0 {
                restSecondsRemaining -= 1
            } else {
                stopRestTimer()
            }
        }
    }

    private func stopRestTimer() {
        restTimer?.invalidate()
        restTimer = nil
        restTimerActive = false
        restSecondsRemaining = 0
    }

    private func saveLog() {
        let log = CalisthenicsLog(week: day.week, day: day.day, durationMinutes: elapsedMinutes)
        log.completedExerciseIds = completedExercises.map { $0.uuidString }
        log.difficulty = difficulty
        log.notes = notes
        context.insert(log)
        onComplete(log)
        dismiss()
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    let isCompleted: Bool
    let isCurrent: Bool
    let onComplete: () -> Void
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        if isCurrent && !isCompleted {
                            Image(systemName: "arrow.right.circle.fill").foregroundStyle(.orange).font(.caption)
                        }
                        Text(exercise.localizedName)
                            .font(.subheadline).fontWeight(.semibold)
                            .strikethrough(isCompleted)
                            .foregroundStyle(isCompleted ? .secondary : .primary)
                    }
                    HStack(spacing: 12) {
                        Label("\(exercise.sets) \(L.sets)", systemImage: "square.stack.3d.up")
                        Label(exercise.repsOrTime, systemImage: "repeat")
                        Label("\(exercise.restSeconds)s", systemImage: "timer")
                    }
                    .font(.caption2).foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    showDetail = true
                } label: {
                    Image(systemName: "info.circle").foregroundStyle(.secondary)
                }

                Button {
                    onComplete()
                } label: {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(isCompleted ? .green : .gray.opacity(0.4))
                }
            }

            if isCurrent && !isCompleted {
                Text(exercise.localizedDescription)
                    .font(.caption).foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }

            if !exercise.targetMuscles.isEmpty {
                HStack(spacing: 4) {
                    ForEach(exercise.targetMuscles, id: \.self) { muscle in
                        Text(muscle)
                            .font(.caption2)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(.orange.opacity(0.12), in: Capsule())
                            .foregroundStyle(.orange)
                    }
                }
            }
        }
        .padding()
        .background(
            isCurrent && !isCompleted
                ? Color.orange.opacity(0.06)
                : Color(.systemBackground),
            in: RoundedRectangle(cornerRadius: 14)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isCurrent && !isCompleted ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.04), radius: 3)
        .sheet(isPresented: $showDetail) { ExerciseDetailSheet(exercise: exercise) }
    }
}

struct ExerciseDetailSheet: View {
    let exercise: Exercise
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(exercise.localizedName).font(.title2).fontWeight(.bold)
                        HStack(spacing: 16) {
                            Label("\(exercise.sets) \(L.sets)", systemImage: "square.stack.3d.up")
                            Label(exercise.repsOrTime, systemImage: "repeat")
                            Label("\(exercise.restSeconds)s \(L.rest)", systemImage: "timer")
                        }
                        .font(.subheadline).foregroundStyle(.orange)
                    }
                    .padding()

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("הסבר").font(.headline).padding(.horizontal)
                        Text(exercise.localizedDescription)
                            .font(.body).padding(.horizontal)
                    }

                    if !exercise.targetMuscles.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("שרירים עיקריים").font(.headline).padding(.horizontal)
                            FlowHStack(items: exercise.targetMuscles)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button(L.done) { dismiss() } } }
        }
    }
}

struct FlowHStack: View {
    let items: [String]
    var body: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.subheadline)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(.orange.opacity(0.12), in: Capsule())
                    .foregroundStyle(.orange)
            }
        }
    }
}

struct RestTimerBanner: View {
    let seconds: Int
    let onSkip: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "timer").foregroundStyle(.blue)
            Text("מנוחה: \(seconds)s")
                .font(.subheadline).fontWeight(.semibold)
            Spacer()
            Button("דלג") { onSkip() }
                .font(.caption).foregroundStyle(.blue)
        }
        .padding()
        .background(.blue.opacity(0.1))
    }
}
