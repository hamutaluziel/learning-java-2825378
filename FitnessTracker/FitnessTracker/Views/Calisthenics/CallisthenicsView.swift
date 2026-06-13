import SwiftUI
import SwiftData

struct CallisthenicsView: View {
    @EnvironmentObject var settings: AppSettings
    @Query(sort: \CalisthenicsLog.date, order: .reverse) var logs: [CalisthenicsLog]
    @State private var showWorkout = false
    @State private var showProgress = false

    var currentWeek: Int { settings.profile.calisthenicsWeek }
    var currentDay: Int { settings.profile.calisthenicsDay }

    var todayTraining: TrainingDay? {
        CallisthenicsProgram.day(week: currentWeek, day: currentDay)
    }

    var completedSessions: Int { logs.count }
    var totalSessions: Int { CallisthenicsProgram.totalWeeks * CallisthenicsProgram.daysPerWeek }
    var progressPercent: Double { Double(completedSessions) / Double(totalSessions) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    programHeaderCard
                    if let day = todayTraining {
                        nextSessionCard(day: day)
                        phaseExplainerCard
                    }
                    recentLogsCard
                }
                .padding()
            }
            .navigationTitle(L.training)
            .sheet(isPresented: $showWorkout) {
                if let day = todayTraining {
                    WorkoutSessionView(day: day) { log in
                        advanceProgram()
                    }
                }
            }
        }
    }

    private var programHeaderCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(format: L.weekOf12, currentWeek))
                        .font(.title3).fontWeight(.bold)
                    Text("יום \(currentDay) מתוך \(CallisthenicsProgram.daysPerWeek)")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(.orange.opacity(0.2), lineWidth: 8)
                        .frame(width: 64, height: 64)
                    Circle()
                        .trim(from: 0, to: progressPercent)
                        .stroke(.orange, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 64, height: 64)
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(progressPercent * 100))%")
                        .font(.caption).fontWeight(.bold)
                }
            }
            ProgressView(value: progressPercent)
                .tint(.orange)
            Text("\(completedSessions) אימונים הושלמו מתוך \(totalSessions)")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4)
    }

    private func nextSessionCard(day: TrainingDay) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L.nextSession).font(.caption).foregroundStyle(.secondary)
                    Text(day.localizedTitle).font(.headline)
                    Label(day.localizedFocus, systemImage: "figure.strengthtraining.traditional")
                        .font(.caption).foregroundStyle(.orange)
                }
                Spacer()
                Text("~40 ד'")
                    .font(.subheadline).foregroundStyle(.secondary)
            }

            Divider()

            ForEach(day.exercises.prefix(3)) { ex in
                HStack {
                    Circle().fill(.orange).frame(width: 6, height: 6)
                    Text(ex.localizedName).font(.subheadline)
                    Spacer()
                    Text("\(ex.sets)×\(ex.repsOrTime)")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
            if day.exercises.count > 3 {
                Text("+ \(day.exercises.count - 3) תרגילים נוספים...")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Button {
                showWorkout = true
            } label: {
                Label(L.startWorkout, systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent).tint(.orange)
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4)
    }

    private var phaseExplainerCard: some View {
        let phase = phaseText(for: currentWeek)
        return HStack(spacing: 12) {
            Image(systemName: "info.circle.fill").foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(phase.title).font(.subheadline).fontWeight(.semibold)
                Text(phase.description).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }

    private var recentLogsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L.sessionHistory).font(.headline)
            if logs.isEmpty {
                Text("לא השלמת אימונים עדיין. התחילי עכשיו!")
                    .font(.caption).foregroundStyle(.secondary)
            } else {
                ForEach(logs.prefix(5)) { log in
                    LogRowView(log: log)
                }
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4)
    }

    private func advanceProgram() {
        var profile = settings.profile
        if profile.calisthenicsDay >= CallisthenicsProgram.daysPerWeek {
            profile.calisthenicsDay = 1
            if profile.calisthenicsWeek < CallisthenicsProgram.totalWeeks {
                profile.calisthenicsWeek += 1
            }
        } else {
            profile.calisthenicsDay += 1
        }
        settings.profile = profile
    }

    private func phaseText(for week: Int) -> (title: String, description: String) {
        switch week {
        case 1...4:
            return ("שלב 1 – יסודות", "בונות בסיס חזק: יציבה, ליבה, ורגליים. ביחד עם ההליכה היומית שלך, הגוף שלך עובר טרנספורמציה!")
        case 5...8:
            return ("שלב 2 – בניית כוח", "עוברים לתרגילים עצימים יותר: שכיבות ברכיים, Dips, תלייה. הכוח גדל בצורה ניכרת!")
        default:
            return ("שלב 3 – קידום מלא", "שכיבות שמיכה מלאות, negative pull-ups, ובסיס קליסתניקס אמיתי. גוף חדש!")
        }
    }
}

struct LogRowView: View {
    let log: CalisthenicsLog
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("שבוע \(log.week) יום \(log.day)")
                    .font(.subheadline).fontWeight(.medium)
                Text(log.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: i <= log.difficulty ? "star.fill" : "star")
                        .font(.caption2)
                        .foregroundStyle(i <= log.difficulty ? .orange : .gray.opacity(0.3))
                }
            }
        }
        .padding(.vertical, 4)
    }
}
