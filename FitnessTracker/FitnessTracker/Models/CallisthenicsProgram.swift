import Foundation
import SwiftData

struct Exercise: Identifiable, Codable {
    let id: UUID
    let nameHe: String
    let nameEn: String
    let sets: Int
    let repsOrTime: String
    let restSeconds: Int
    let descriptionHe: String
    let descriptionEn: String
    let videoNote: String
    let targetMuscles: [String]

    init(
        nameHe: String, nameEn: String,
        sets: Int, repsOrTime: String,
        restSeconds: Int = 60,
        descriptionHe: String, descriptionEn: String,
        videoNote: String = "",
        targetMuscles: [String] = []
    ) {
        self.id = UUID()
        self.nameHe = nameHe
        self.nameEn = nameEn
        self.sets = sets
        self.repsOrTime = repsOrTime
        self.restSeconds = restSeconds
        self.descriptionHe = descriptionHe
        self.descriptionEn = descriptionEn
        self.videoNote = videoNote
        self.targetMuscles = targetMuscles
    }

    var localizedName: String { AppSettings.shared.isHebrew ? nameHe : nameEn }
    var localizedDescription: String { AppSettings.shared.isHebrew ? descriptionHe : descriptionEn }
}

struct TrainingDay: Identifiable, Codable {
    let id: UUID
    let week: Int
    let day: Int
    let titleHe: String
    let titleEn: String
    let focusHe: String
    let focusEn: String
    let exercises: [Exercise]
    let warmupNote: String
    let cooldownNote: String

    init(
        week: Int, day: Int,
        titleHe: String, titleEn: String,
        focusHe: String, focusEn: String,
        exercises: [Exercise],
        warmupNote: String = "",
        cooldownNote: String = ""
    ) {
        self.id = UUID()
        self.week = week
        self.day = day
        self.titleHe = titleHe
        self.titleEn = titleEn
        self.focusHe = focusHe
        self.focusEn = focusEn
        self.exercises = exercises
        self.warmupNote = warmupNote
        self.cooldownNote = cooldownNote
    }

    var localizedTitle: String { AppSettings.shared.isHebrew ? titleHe : titleEn }
    var localizedFocus: String { AppSettings.shared.isHebrew ? focusHe : focusEn }
}

@Model
final class CalisthenicsLog {
    var id: UUID
    var date: Date
    var week: Int
    var day: Int
    var completedExerciseIds: [String]
    var notes: String
    var durationMinutes: Int
    var difficulty: Int

    init(week: Int, day: Int, durationMinutes: Int = 0) {
        self.id = UUID()
        self.date = .now
        self.week = week
        self.day = day
        self.completedExerciseIds = []
        self.notes = ""
        self.durationMinutes = durationMinutes
        self.difficulty = 3
    }
}
