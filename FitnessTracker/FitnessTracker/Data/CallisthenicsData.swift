import Foundation

// Complete 12-week calisthenics program designed for a 46+ woman, 80kg, great cardio base.
// Focus: progressive body shaping starting from absolute beginner level.
// 3 sessions/week (leave room for daily cardio). Each session ~35-45 min.
struct CallisthenicsProgram {
    static let allDays: [TrainingDay] = week1 + week2 + week3 + week4 + week5 + week6 + week7 + week8 + week9 + week10 + week11 + week12

    static func day(week: Int, day: Int) -> TrainingDay? {
        allDays.first { $0.week == week && $0.day == day }
    }

    static let totalWeeks = 12
    static let daysPerWeek = 3

    // MARK: - Week 1-2: Foundation
    static let week1: [TrainingDay] = [
        TrainingDay(
            week: 1, day: 1,
            titleHe: "יום 1 – עמדות ויסוד",
            titleEn: "Day 1 – Foundation & Posture",
            focusHe: "חזה, כתפיים, ליבה",
            focusEn: "Chest, Shoulders, Core",
            exercises: [
                Exercise(
                    nameHe: "שכיבות שמיכה מהקיר",
                    nameEn: "Wall Push-Ups",
                    sets: 3, repsOrTime: "12",
                    restSeconds: 60,
                    descriptionHe: "עמדי מול הקיר, ידיים בגובה החזה, כפות הרגליים 50ס\"מ מהקיר. כופפי מרפקים לאיטי (2 שניות ירידה, 1 שניה עלייה). גב ישר לאורך כל התרגיל.",
                    descriptionEn: "Stand facing wall, hands at chest height, feet 50cm back. Bend elbows slowly (2s down, 1s up). Keep back straight.",
                    targetMuscles: ["חזה", "כתפיים", "טריצפס"]
                ),
                Exercise(
                    nameHe: "סקוואט עם כיסא",
                    nameEn: "Chair-Assisted Squat",
                    sets: 3, repsOrTime: "15",
                    restSeconds: 60,
                    descriptionHe: "עמדי מול כיסא, רגליים ברוחב כתפיים. שבי לאיטי (3 שניות) עד שהישבן נוגע בכיסא, קומי מיד. שמרי על ברכיים מעל בהונות.",
                    descriptionEn: "Stand before chair, feet shoulder-width apart. Sit down slowly (3s), touch chair, rise immediately. Keep knees over toes.",
                    targetMuscles: ["ירכיים", "ישבן", "שוקיים"]
                ),
                Exercise(
                    nameHe: "גשר ישבן (Glute Bridge)",
                    nameEn: "Glute Bridge",
                    sets: 3, repsOrTime: "15",
                    restSeconds: 60,
                    descriptionHe: "שכבי על הגב, ברכיים כפופות, כפות רגליים על הרצפה. הרימי את האגן עד שהגוף ביוצר קו ישר מברכיים לכתפיים. החזיקי 2 שניות, ורדי לאיטי.",
                    descriptionEn: "Lie on back, knees bent, feet flat. Lift hips until body forms a straight line from knees to shoulders. Hold 2s, lower slowly.",
                    targetMuscles: ["ישבן", "ירכיים אחוריות"]
                ),
                Exercise(
                    nameHe: "פלאנק על ברכיים",
                    nameEn: "Knee Plank",
                    sets: 3, repsOrTime: "20 שניות",
                    restSeconds: 45,
                    descriptionHe: "עמדי על ידיים וברכיים, גוף ישר מברכיים לראש. מתח בטן, גב שטוח. נשמי בצורה רגועה. גבי ישר!",
                    descriptionEn: "On hands and knees, body straight from knees to head. Engage core, flat back. Breathe calmly.",
                    targetMuscles: ["ליבה", "שרירי גב תחתון"]
                ),
                Exercise(
                    nameHe: "סופרמן",
                    nameEn: "Superman",
                    sets: 3, repsOrTime: "10",
                    restSeconds: 45,
                    descriptionHe: "שכבי על הבטן, ידיים מושטות קדימה. הרימי ידיים ורגליים בו זמנית 5 ס\"מ מהרצפה, החזיקי 2 שניות, ורדי.",
                    descriptionEn: "Lie face down, arms extended forward. Lift arms and legs simultaneously 5cm off floor, hold 2s, lower.",
                    targetMuscles: ["גב תחתון", "ישבן", "ירכיים אחוריות"]
                )
            ],
            warmupNote: "5 דקות: 20 מעגלי כתפיים, 20 הטיות גוף, 10 מעגלי ירכיים לכל כיוון, 30 שניות צעידה במקום",
            cooldownNote: "5 דקות מתיחות: חזה, ירכיים קדמיות, ישבן, גב תחתון"
        ),
        TrainingDay(
            week: 1, day: 2,
            titleHe: "יום 2 – גב ורגליים",
            titleEn: "Day 2 – Back & Legs",
            focusHe: "גב, ישבן, ירכיים",
            focusEn: "Back, Glutes, Hamstrings",
            exercises: [
                Exercise(
                    nameHe: "שורת הגמל (Bird Dog)",
                    nameEn: "Bird Dog",
                    sets: 3, repsOrTime: "10 לכל צד",
                    restSeconds: 45,
                    descriptionHe: "על ארבע, גב ישר. האריכי יד ימין ורגל שמאל בו זמנית, החזיקי 3 שניות. עברי לצד השני. שמרי על איזון וגב שטוח.",
                    descriptionEn: "On all fours, flat back. Extend right arm and left leg simultaneously, hold 3s. Switch sides. Maintain balance.",
                    targetMuscles: ["גב תחתון", "ליבה", "ישבן"]
                ),
                Exercise(
                    nameHe: "לאנג' קדמי (Reverse Lunge)",
                    nameEn: "Reverse Lunge",
                    sets: 3, repsOrTime: "10 לכל רגל",
                    restSeconds: 60,
                    descriptionHe: "עמדי ישר, צעדי רגל אחת אחורה ורדי עד שהברך האחורית קרובה לרצפה. קומי וחזרי. אחזי בקיר לתמיכה אם צריך.",
                    descriptionEn: "Stand tall, step one foot back and lower until back knee almost touches floor. Rise and return. Hold wall for balance if needed.",
                    targetMuscles: ["ישבן", "ירכיים", "שוקיים"]
                ),
                Exercise(
                    nameHe: "גשר ישבן עם רגל מורמת",
                    nameEn: "Single-Leg Glute Bridge",
                    sets: 2, repsOrTime: "8 לכל רגל",
                    restSeconds: 60,
                    descriptionHe: "גשר ישבן רגיל, אך הרימי רגל אחת מהרצפה. שמרי על אגן מאוזן. קשה? חזרי לגשר כפול רגל.",
                    descriptionEn: "Standard glute bridge but lift one foot off floor. Keep hips level. Too hard? Return to both feet.",
                    targetMuscles: ["ישבן", "ירכיים אחוריות", "ליבה"]
                ),
                Exercise(
                    nameHe: "העלאת עקבים (Calf Raise)",
                    nameEn: "Calf Raise",
                    sets: 3, repsOrTime: "20",
                    restSeconds: 45,
                    descriptionHe: "עמדי על קצות האצבעות, עצרי שניה למעלה, ורדי לאיטי. אחזי בקיר לאיזון. רגליים ביחד.",
                    descriptionEn: "Rise on toes, pause at top, lower slowly. Hold wall for balance.",
                    targetMuscles: ["שוקיים"]
                ),
                Exercise(
                    nameHe: "פלאנק עם אפשרות כוכב",
                    nameEn: "Plank",
                    sets: 3, repsOrTime: "25 שניות",
                    restSeconds: 45,
                    descriptionHe: "פלאנק על ידיים (או ברכיים). מתח בטן, שמרי על קו גוף ישר. שאיפה מהאף, נשיפה מהפה.",
                    descriptionEn: "Plank on hands (or knees). Engage core, maintain straight body line. Inhale through nose, exhale through mouth.",
                    targetMuscles: ["ליבה", "כתפיים"]
                )
            ],
            warmupNote: "5 דקות: 20 כפיפות ברך קטנות, 10 מעגלי ירכיים, 20 צד-צד עם גוף עליון, הליכה במקום 30 שניות",
            cooldownNote: "5 דקות מתיחות: ירכיים, שוקיים, גב תחתון, לאנג' מתיחה"
        ),
        TrainingDay(
            week: 1, day: 3,
            titleHe: "יום 3 – כולל גוף קל",
            titleEn: "Day 3 – Full Body Light",
            focusHe: "כל הגוף, תיאום עצבי-שרירי",
            focusEn: "Full Body, Neuromuscular Coordination",
            exercises: [
                Exercise(
                    nameHe: "שכיבות שמיכה מהקיר", nameEn: "Wall Push-Ups",
                    sets: 3, repsOrTime: "15",
                    descriptionHe: "כמו יום 1 אך 15 חזרות. תרגישי את החזה עובד.",
                    descriptionEn: "Like Day 1 but 15 reps. Feel your chest working.",
                    targetMuscles: ["חזה", "כתפיים"]
                ),
                Exercise(
                    nameHe: "סקוואט ללא כיסא", nameEn: "Bodyweight Squat",
                    sets: 3, repsOrTime: "15",
                    descriptionHe: "ללא הכיסא עכשיו! ידיים קדימה לאיזון, ירדי לזווית 90°.",
                    descriptionEn: "No chair now! Arms forward for balance, lower to 90° angle.",
                    targetMuscles: ["ירכיים", "ישבן"]
                ),
                Exercise(
                    nameHe: "גשר ישבן", nameEn: "Glute Bridge",
                    sets: 3, repsOrTime: "20",
                    descriptionHe: "מהיר יותר – 1 שניה למעלה, 1 שניה למטה.",
                    descriptionEn: "Quicker pace – 1s up, 1s down.",
                    targetMuscles: ["ישבן", "ירכיים"]
                ),
                Exercise(
                    nameHe: "Dead Bug", nameEn: "Dead Bug",
                    sets: 3, repsOrTime: "8 לכל צד",
                    restSeconds: 45,
                    descriptionHe: "שכבי על הגב, ידיים ישר לתקרה, ברכיים מעל ירכיים בזווית 90°. הורידי יד ימין ורגל שמאל לאיטי עד קרוב לרצפה, חזרי. גב תחתון צמוד לרצפה!",
                    descriptionEn: "Lie on back, arms to ceiling, knees over hips at 90°. Lower right arm and left leg slowly toward floor, return. Keep lower back pressed to floor!",
                    targetMuscles: ["ליבה עמוקה", "יציבה"]
                ),
                Exercise(
                    nameHe: "פלאנק", nameEn: "Plank",
                    sets: 3, repsOrTime: "30 שניות",
                    descriptionHe: "30 שניות! אם קשה - ברכיים. מצוין!",
                    descriptionEn: "30 seconds! Too hard? Drop to knees. Great work!",
                    targetMuscles: ["ליבה"]
                )
            ],
            warmupNote: "5 דקות: מתיחה דינמית – 10 נדנדות רגל, 10 מעגלי ידיים, 10 פיתולי גוף, 30 שניות קפיצות קטנות",
            cooldownNote: "מתיחות + 2 דקות נשימות עמוקות – גאה בעצמך!"
        )
    ]

    static let week2 = week1.map { day in
        TrainingDay(
            week: 2, day: day.day,
            titleHe: day.titleHe,
            titleEn: day.titleEn,
            focusHe: day.focusHe,
            focusEn: day.focusEn,
            exercises: day.exercises.map { ex in
                let repsInt = Int(ex.repsOrTime.components(separatedBy: " ").first ?? "0") ?? 0
                let newReps = repsInt > 0 ? "\(repsInt + 2)" : ex.repsOrTime
                return Exercise(
                    nameHe: ex.nameHe, nameEn: ex.nameEn,
                    sets: ex.sets, repsOrTime: newReps,
                    restSeconds: max(ex.restSeconds - 5, 40),
                    descriptionHe: ex.descriptionHe,
                    descriptionEn: ex.descriptionEn,
                    targetMuscles: ex.targetMuscles
                )
            },
            warmupNote: day.warmupNote, cooldownNote: day.cooldownNote
        )
    }

    // MARK: - Week 3-4: Progression
    static let week3: [TrainingDay] = [
        TrainingDay(
            week: 3, day: 1,
            titleHe: "שבוע 3 יום 1 – שכיבות שמיכה נטויות",
            titleEn: "Week 3 Day 1 – Incline Push-Ups",
            focusHe: "חזה, כתפיים, טריצפס",
            focusEn: "Chest, Shoulders, Triceps",
            exercises: [
                Exercise(
                    nameHe: "שכיבות שמיכה נטויות (על שולחן)",
                    nameEn: "Incline Push-Ups (on table)",
                    sets: 3, repsOrTime: "10",
                    descriptionHe: "ידיים על שולחן בגובה בטן. גוף ישר, הורידי את החזה לשולחן. קשה יותר מהקיר, קל יותר מהרצפה.",
                    descriptionEn: "Hands on a table at waist height. Straight body, lower chest to table. Harder than wall, easier than floor.",
                    targetMuscles: ["חזה", "כתפיים", "טריצפס"]
                ),
                Exercise(
                    nameHe: "סקוואט עמוק",
                    nameEn: "Deep Squat",
                    sets: 3, repsOrTime: "15",
                    descriptionHe: "ירדי נמוך ככל שאפשר, עקבים על הרצפה. אחזי בדלת לתמיכה אם צריך. עבדי על גמישות הירכיים.",
                    descriptionEn: "Go as low as comfortable, heels on floor. Hold door frame if needed. Work on hip flexibility.",
                    targetMuscles: ["ירכיים", "ישבן", "שוקיים"]
                ),
                Exercise(
                    nameHe: "גשר ישבן רגל אחת",
                    nameEn: "Single-Leg Glute Bridge",
                    sets: 3, repsOrTime: "12 לכל רגל",
                    descriptionHe: "גשר ישבן עם רגל אחת מורמת, 12 חזרות לכל צד.",
                    descriptionEn: "Glute bridge with one leg raised, 12 reps each side.",
                    targetMuscles: ["ישבן", "ירכיים"]
                ),
                Exercise(
                    nameHe: "פלאנק צד",
                    nameEn: "Side Plank (Modified)",
                    sets: 2, repsOrTime: "20 שניות לכל צד",
                    descriptionHe: "שכבי על הצד, נשענת על כף יד וברך. הרימי ישבן. גב ישר! 20 שניות לכל צד.",
                    descriptionEn: "Lie on side, supported on hand and knee. Lift hips. Straight back! 20s each side.",
                    targetMuscles: ["ליבה צדדית", "ירכיים"]
                ),
                Exercise(
                    nameHe: "לאנג' הליכה",
                    nameEn: "Walking Lunge",
                    sets: 2, repsOrTime: "10 לכל רגל",
                    descriptionHe: "לאנג' צועד קדימה. 10 לכל רגל ברצף בלי לחזור לעמידה באמצע.",
                    descriptionEn: "Step forward into lunge. 10 each leg continuously without stopping.",
                    targetMuscles: ["ישבן", "ירכיים", "שוקיים"]
                )
            ],
            warmupNote: "5 דקות דינמי: 20 הפרדות רגליים, 20 נדנדות רגל, 10 מעגלי ירכיים, 1 דקה הליכה מהירה במקום",
            cooldownNote: "5 דקות מתיחות סטטיות: חזה (30 שניות כל צד), ירכיים, שוקיים"
        ),
        TrainingDay(
            week: 3, day: 2,
            titleHe: "שבוע 3 יום 2 – כוח גוף עליון",
            titleEn: "Week 3 Day 2 – Upper Body Strength",
            focusHe: "גב, כתפיים, ביצפס",
            focusEn: "Back, Shoulders, Biceps",
            exercises: [
                Exercise(
                    nameHe: "שכיבות שמיכה להיפוך (Pike Push-Up בסיסי)",
                    nameEn: "Pike Push-Up (Basic)",
                    sets: 3, repsOrTime: "8",
                    descriptionHe: "עמדי כשהגוף ביוצר V הפוך, ידיים על הרצפה, רגליים קרובות. כופפי מרפקים להורדת הראש לכיוון הרצפה. עובד על כתפיים!",
                    descriptionEn: "Stand in inverted V position, hands on floor. Bend elbows to lower head toward floor. Works shoulders!",
                    targetMuscles: ["כתפיים", "טריצפס", "גב עליון"]
                ),
                Exercise(
                    nameHe: "שורת גוף עליון מהשולחן (Table Row)",
                    nameEn: "Table Row / Inverted Row",
                    sets: 3, repsOrTime: "10",
                    descriptionHe: "שכבי מתחת לשולחן, אחזי בקצה השולחן, גוף ישר. משכי את עצמך לשולחן. אם אין שולחן מתאים – בדלת פתוחה.",
                    descriptionEn: "Lie under table, grip edge, straight body. Pull yourself up to table. No table? Use an open door frame.",
                    targetMuscles: ["גב", "ביצפס", "כתפיים אחוריות"]
                ),
                Exercise(
                    nameHe: "לאנג' צידי", nameEn: "Lateral Lunge",
                    sets: 3, repsOrTime: "10 לכל רגל",
                    descriptionHe: "פסיעה רחבה לצד, כופפי ברך צדדית בעוד הרגל השנייה ישרה. חזרי לאמצע.",
                    descriptionEn: "Wide step to side, bend the side knee while keeping other leg straight. Return to center.",
                    targetMuscles: ["ירכיים פנימיות", "ישבן"]
                ),
                Exercise(
                    nameHe: "כפיפות בטן בסיסיות", nameEn: "Basic Crunches",
                    sets: 3, repsOrTime: "15",
                    descriptionHe: "שכבי על הגב, ברכיים כפופות, ידיים מאחורי הראש בלי למשוך. הרימי כתפיים מהרצפה 20-30°. אחרי 3.5 חודשי ליבה חזקה – זה קל לך!",
                    descriptionEn: "On back, knees bent, hands behind head without pulling. Raise shoulders 20-30° off floor.",
                    targetMuscles: ["בטן עליונה"]
                ),
                Exercise(
                    nameHe: "פלאנק + נגיעת כתף", nameEn: "Plank Shoulder Taps",
                    sets: 3, repsOrTime: "10 לכל כתף",
                    descriptionHe: "בפלאנק על ידיים, נגעי בכתף שמאל עם יד ימין. שמרי על ישבן יציב! גב ישר.",
                    descriptionEn: "In high plank, tap left shoulder with right hand. Keep hips stable! Flat back.",
                    targetMuscles: ["ליבה", "כתפיים", "חזה"]
                )
            ],
            warmupNote: "5 דקות: מעגלי ידיים ומרפקים, 10 נטיות קדימה, 20 קפיצות קטנות, 30 שניות בוקס שאדו",
            cooldownNote: "מתיחות: כתפיים (בדלת), גב עליון (חיבוק), ירכיים"
        ),
        TrainingDay(
            week: 3, day: 3,
            titleHe: "שבוע 3 יום 3 – כוח וסיבולת",
            titleEn: "Week 3 Day 3 – Strength & Endurance",
            focusHe: "כל הגוף, סבבי עומס",
            focusEn: "Full Body, Circuit Training",
            exercises: [
                Exercise(
                    nameHe: "סבב: 3 תרגילים ×3",
                    nameEn: "Circuit: 3 exercises ×3",
                    sets: 3, repsOrTime: "40 שניות + 20 שניות מנוחה",
                    restSeconds: 90,
                    descriptionHe: "3 סבבים של: (1) שכיבות שמיכה נטויות 40 שניות → (2) סקוואט 40 שניות → (3) פלאנק 40 שניות. 90 שניות מנוחה בין סבבים.",
                    descriptionEn: "3 rounds of: (1) Incline push-ups 40s → (2) Squats 40s → (3) Plank 40s. 90s rest between rounds.",
                    targetMuscles: ["כל הגוף"]
                ),
                Exercise(
                    nameHe: "Dead Bug",
                    nameEn: "Dead Bug",
                    sets: 3, repsOrTime: "10 לכל צד",
                    descriptionHe: "מיקוד על בטן עמוקה. נשימה החוצה בזמן הורדת הגפיים.",
                    descriptionEn: "Focus on deep core. Exhale as you lower limbs.",
                    targetMuscles: ["ליבה עמוקה"]
                ),
                Exercise(
                    nameHe: "גשר ישבן 30 חזרות", nameEn: "Glute Bridge Burnout",
                    sets: 1, repsOrTime: "30",
                    restSeconds: 60,
                    descriptionHe: "30 חזרות רציפות – שחרור עצבי ישבן! סיבולת שרירי ישבן.",
                    descriptionEn: "30 continuous reps – glute endurance burnout!",
                    targetMuscles: ["ישבן"]
                )
            ],
            warmupNote: "10 דקות הליכה מהירה + מתיחות דינמיות",
            cooldownNote: "מתיחות ארוכות 8 דקות – מגיע לך אחרי 3 אימונים השבוע!"
        )
    ]

    static let week4 = week3.map { day in
        TrainingDay(
            week: 4, day: day.day,
            titleHe: day.titleHe.replacingOccurrences(of: "שבוע 3", with: "שבוע 4"),
            titleEn: day.titleEn.replacingOccurrences(of: "Week 3", with: "Week 4"),
            focusHe: day.focusHe, focusEn: day.focusEn,
            exercises: day.exercises.map { ex in
                Exercise(
                    nameHe: ex.nameHe, nameEn: ex.nameEn,
                    sets: min(ex.sets + 1, 4), repsOrTime: ex.repsOrTime,
                    restSeconds: max(ex.restSeconds - 10, 30),
                    descriptionHe: ex.descriptionHe, descriptionEn: ex.descriptionEn,
                    targetMuscles: ex.targetMuscles
                )
            },
            warmupNote: day.warmupNote, cooldownNote: day.cooldownNote
        )
    }

    // MARK: - Week 5-8: Building Strength
    static let week5: [TrainingDay] = [
        TrainingDay(
            week: 5, day: 1,
            titleHe: "שבוע 5 יום 1 – שכיבות שמיכה על ברכיים",
            titleEn: "Week 5 Day 1 – Knee Push-Ups",
            focusHe: "חזה, טריצפס, ליבה",
            focusEn: "Chest, Triceps, Core",
            exercises: [
                Exercise(
                    nameHe: "שכיבות שמיכה על ברכיים",
                    nameEn: "Knee Push-Ups",
                    sets: 4, repsOrTime: "10",
                    descriptionHe: "ידיים ורגליים על הרצפה, ברכיים כפופות, גוף ישר מברכיים לראש. הורידי חזה לרצפה (2 שניות), דחפי חזרה (1 שניה). זה השלב הגדול!",
                    descriptionEn: "Hands and knees on floor, straight body from knees to head. Lower chest to floor (2s), push back (1s). This is a big step!",
                    targetMuscles: ["חזה", "טריצפס", "כתפיים"]
                ),
                Exercise(
                    nameHe: "סקוואט קפיצה (Jump Squat מתון)",
                    nameEn: "Gentle Jump Squat",
                    sets: 3, repsOrTime: "10",
                    restSeconds: 60,
                    descriptionHe: "סקוואט רגיל + קפיצה קלה בעלייה. נחיתה רכה! אם מפרקים רגישים – המשך סקוואט רגיל.",
                    descriptionEn: "Regular squat + gentle jump at top. Soft landing! If joints are sensitive, continue regular squats.",
                    targetMuscles: ["ירכיים", "ישבן", "שוקיים"]
                ),
                Exercise(
                    nameHe: "Dip על כיסא",
                    nameEn: "Chair Dip",
                    sets: 3, repsOrTime: "8",
                    descriptionHe: "שבי בקצה הכיסא, ידיים בצדדים. הורידי גוף לפני הכיסא על ידי כפיפת מרפקים, קומי. מרפקים אחורה, לא לצדדים.",
                    descriptionEn: "Sit at edge of chair, hands at sides. Lower body in front by bending elbows, push back up. Elbows backward, not outward.",
                    targetMuscles: ["טריצפס", "כתפיים"]
                ),
                Exercise(
                    nameHe: "פלאנק מלא",
                    nameEn: "Full Plank",
                    sets: 3, repsOrTime: "30 שניות",
                    descriptionHe: "עכשיו פלאנק מלא על ידיים ואצבעות רגליים. גב ישר, ישבן לא למעלה ולא למטה.",
                    descriptionEn: "Full plank on hands and toes. Flat back, hips not too high or low.",
                    targetMuscles: ["ליבה", "כתפיים"]
                ),
                Exercise(
                    nameHe: "V-Sit (מושב V)",
                    nameEn: "V-Sit Hold",
                    sets: 3, repsOrTime: "15 שניות",
                    restSeconds: 45,
                    descriptionHe: "שבי על הרצפה, הרימי רגליים בזווית 45° ופרשי ידיים. שמרי על גב ישר. תרגיש ביוצר V עם הגוף.",
                    descriptionEn: "Sit on floor, raise legs to 45° angle with arms out. Maintain straight back. Body forms a V shape.",
                    targetMuscles: ["בטן", "ירכיים קדמיות"]
                )
            ],
            warmupNote: "5 דקות + 5 שכיבות שמיכה קלות מהקיר לחימום ידיים ומפרקים",
            cooldownNote: "מתיחות חזה (חשוב!), טריצפס, ירכיים, 2 דקות נשימות"
        ),
        TrainingDay(
            week: 5, day: 2,
            titleHe: "שבוע 5 יום 2 – גב וריצה",
            titleEn: "Week 5 Day 2 – Back & Pulls",
            focusHe: "גב, ביצפס, ישבן",
            focusEn: "Back, Biceps, Glutes",
            exercises: [
                Exercise(
                    nameHe: "תלייה פסיבית (Dead Hang)",
                    nameEn: "Dead Hang",
                    sets: 3, repsOrTime: "20 שניות",
                    restSeconds: 60,
                    descriptionHe: "תלי מבר מתח (מסגרת דלת, מוט נמוך). תנחי לגוף לתלות באופן פסיבי. מחזקת אחיזה, כתפיים, ודקומפרסיה של עמוד שדרה.",
                    descriptionEn: "Hang from a pull-up bar (door frame, low bar). Let body hang passively. Strengthens grip, shoulders, decompresses spine.",
                    targetMuscles: ["כתפיים", "גב", "אחיזה"]
                ),
                Exercise(
                    nameHe: "שורת גוף עליון (Inverted Row)",
                    nameEn: "Inverted Row",
                    sets: 3, repsOrTime: "8",
                    descriptionHe: "שכבי מתחת לשולחן/מוט נמוך, גוף ישר. משכי עצמך עם ידיים לרוחב לכיוון המוט. זה כמו שכיבות משיכה – רק הפוך!",
                    descriptionEn: "Lie under table/low bar, straight body. Pull yourself up with wide grip toward bar. Like pull-ups – but inverted!",
                    targetMuscles: ["גב רחב", "ביצפס"]
                ),
                Exercise(
                    nameHe: "Sumo Squat", nameEn: "Sumo Squat",
                    sets: 3, repsOrTime: "15",
                    descriptionHe: "רגליים פשוקות רחב, בהונות החוצה 45°. ירדי עמוק. מדגישה ירכיים פנימיות וישבן.",
                    descriptionEn: "Feet wide apart, toes 45° out. Go deep. Emphasizes inner thighs and glutes.",
                    targetMuscles: ["ירכיים פנימיות", "ישבן"]
                ),
                Exercise(
                    nameHe: "Superman עם החזקה",
                    nameEn: "Superman Hold",
                    sets: 3, repsOrTime: "10 × 3 שניות",
                    descriptionHe: "סופרמן כמו שבוע 1 אך עם החזקת 3 שניות למעלה.",
                    descriptionEn: "Superman like Week 1 but with 3-second hold at top.",
                    targetMuscles: ["גב תחתון", "ישבן"]
                ),
                Exercise(
                    nameHe: "Mountain Climbers מתונים",
                    nameEn: "Slow Mountain Climbers",
                    sets: 3, repsOrTime: "10 לכל רגל",
                    descriptionHe: "בפלאנק, הביאי ברך לחזה לאיטי. 10 לכל רגל. ישבן ישר, לא מורם.",
                    descriptionEn: "In plank, bring knee to chest slowly. 10 each leg. Hips level, not raised.",
                    targetMuscles: ["ליבה", "ירכיים"]
                )
            ],
            warmupNote: "5 דקות כולל מעגלי ידיים ורגלים, פיתול גוף, 30 שניות צד-צד",
            cooldownNote: "מתיחות: גב (ילד), חזה, ירכיים, שוקיים"
        ),
        TrainingDay(
            week: 5, day: 3,
            titleHe: "שבוע 5 יום 3 – סיבולת כוח",
            titleEn: "Week 5 Day 3 – Strength Endurance",
            focusHe: "סבב כל הגוף עם עומס מוגדל",
            focusEn: "Full Body Circuit, Increased Load",
            exercises: [
                Exercise(
                    nameHe: "4 סבבים × 4 תרגילים",
                    nameEn: "4 Rounds × 4 Exercises",
                    sets: 4, repsOrTime: "45 שניות עבודה + 15 שניות מנוחה",
                    restSeconds: 120,
                    descriptionHe: "4 סבבים: (1) שכיבות שמיכה ברכיים 45 שניות → (2) סקוואט קפיצה 45 שניות → (3) Inverted Row 45 שניות → (4) פלאנק 45 שניות. 2 דקות מנוחה בין סבבים.",
                    descriptionEn: "4 rounds: (1) Knee push-ups 45s → (2) Jump squats 45s → (3) Inverted row 45s → (4) Plank 45s. 2 min rest between rounds.",
                    targetMuscles: ["כל הגוף"]
                )
            ],
            warmupNote: "8 דקות חימום מלא כולל קפיצות קטנות",
            cooldownNote: "10 דקות מתיחות מלאות + קצת מדיטציה – מדהים!"
        )
    ]

    static let week6 = week5.map { day in
        TrainingDay(
            week: 6, day: day.day,
            titleHe: day.titleHe.replacingOccurrences(of: "שבוע 5", with: "שבוע 6"),
            titleEn: day.titleEn.replacingOccurrences(of: "Week 5", with: "Week 6"),
            focusHe: day.focusHe, focusEn: day.focusEn,
            exercises: day.exercises,
            warmupNote: day.warmupNote, cooldownNote: day.cooldownNote
        )
    }

    static let week7 = week5.map { day in
        TrainingDay(
            week: 7, day: day.day,
            titleHe: day.titleHe.replacingOccurrences(of: "שבוע 5", with: "שבוע 7"),
            titleEn: day.titleEn.replacingOccurrences(of: "Week 5", with: "Week 7"),
            focusHe: day.focusHe, focusEn: day.focusEn,
            exercises: day.exercises.map { ex in
                Exercise(
                    nameHe: ex.nameHe, nameEn: ex.nameEn,
                    sets: min(ex.sets + 1, 5), repsOrTime: ex.repsOrTime,
                    restSeconds: ex.restSeconds,
                    descriptionHe: ex.descriptionHe, descriptionEn: ex.descriptionEn,
                    targetMuscles: ex.targetMuscles
                )
            },
            warmupNote: day.warmupNote, cooldownNote: day.cooldownNote
        )
    }

    static let week8 = week7.map { day in
        TrainingDay(
            week: 8, day: day.day,
            titleHe: day.titleHe.replacingOccurrences(of: "שבוע 7", with: "שבוע 8"),
            titleEn: day.titleEn.replacingOccurrences(of: "Week 7", with: "Week 8"),
            focusHe: day.focusHe, focusEn: day.focusEn,
            exercises: day.exercises,
            warmupNote: day.warmupNote, cooldownNote: day.cooldownNote
        )
    }

    // MARK: - Week 9-12: Progressive Overload
    static let week9: [TrainingDay] = [
        TrainingDay(
            week: 9, day: 1,
            titleHe: "שבוע 9 יום 1 – שכיבות שמיכה מלאות!",
            titleEn: "Week 9 Day 1 – Full Push-Ups!",
            focusHe: "חזה, כתפיים, ליבה – רמה מלאה",
            focusEn: "Chest, Shoulders, Core – Full Level",
            exercises: [
                Exercise(
                    nameHe: "שכיבות שמיכה מלאות",
                    nameEn: "Full Push-Ups",
                    sets: 4, repsOrTime: "5-8",
                    descriptionHe: "פלאנק מלא, הורידי חזה לרצפה. אם 5 קשה – עשי 3 מלאות + 2 על ברכיים. כוח רצון! זה הישג עצום!",
                    descriptionEn: "Full plank, lower chest to floor. If 5 is hard – do 3 full + 2 on knees. This is a huge achievement!",
                    targetMuscles: ["חזה", "טריצפס", "כתפיים", "ליבה"]
                ),
                Exercise(
                    nameHe: "Dip על כיסא (עמוק)",
                    nameEn: "Deep Chair Dip",
                    sets: 3, repsOrTime: "10",
                    descriptionHe: "Dip עמוק יותר – ירדי עד ש-90° במרפק.",
                    descriptionEn: "Deeper dip – go until 90° elbow bend.",
                    targetMuscles: ["טריצפס"]
                ),
                Exercise(
                    nameHe: "Bulgarian Split Squat",
                    nameEn: "Bulgarian Split Squat",
                    sets: 3, repsOrTime: "8 לכל רגל",
                    restSeconds: 75,
                    descriptionHe: "עמדי מול כיסא, הנחי כף רגל אחורית על הכיסא. ירדי בסקוואט עם הרגל הקדמית. מאוד מאתגר!",
                    descriptionEn: "Stand before chair, place rear foot on seat. Squat with front leg. Very challenging!",
                    targetMuscles: ["ישבן", "ירכיים", "שוקיים"]
                ),
                Exercise(
                    nameHe: "Plank to Down-Dog",
                    nameEn: "Plank to Down-Dog",
                    sets: 3, repsOrTime: "10",
                    descriptionHe: "מפלאנק מלא, הרימי ישבן ליוגה Down Dog, חזרי לפלאנק.",
                    descriptionEn: "From full plank, raise hips to yoga Down Dog, return to plank.",
                    targetMuscles: ["ליבה", "כתפיים", "שוקיים"]
                ),
                Exercise(
                    nameHe: "L-Sit על כיסאות",
                    nameEn: "L-Sit on Chairs",
                    sets: 3, repsOrTime: "10 שניות",
                    restSeconds: 60,
                    descriptionHe: "שתי ידיים על כיסאות לצדדיך, דחפי למטה, הרימי גוף. הסטרט לתרגיל L-sit – מהבסיס של קליסתניקס!",
                    descriptionEn: "Two chairs beside you, push down on seats, lift body. The start of L-sit – a calisthenics foundation!",
                    targetMuscles: ["טריצפס", "ליבה", "כתפיים"]
                )
            ],
            warmupNote: "8 דקות – 5 שכיבות ברכיים, 10 סקוואטים, מתיחות דינמיות",
            cooldownNote: "10 דקות מתיחות – מגיע לך! שבוע 9 זה הישג אמיתי."
        ),
        TrainingDay(
            week: 9, day: 2,
            titleHe: "שבוע 9 יום 2 – שלב Pull-Up",
            titleEn: "Week 9 Day 2 – Pull-Up Foundation",
            focusHe: "גב, ביצפס – הכנה לשלייה",
            focusEn: "Back, Biceps – Pull-Up Prep",
            exercises: [
                Exercise(
                    nameHe: "Dead Hang עם כיווץ כתפיים",
                    nameEn: "Dead Hang with Shoulder Retraction",
                    sets: 4, repsOrTime: "25 שניות",
                    descriptionHe: "תלי, אחר כך ציירי כתפיים אחורה ומטה (כמו לשים שתי ידיים בכיסים). זה הצעד הראשון לעלייה!",
                    descriptionEn: "Hang, then retract shoulders back and down (like putting hands in back pockets). This is the first step to pulling up!",
                    targetMuscles: ["כתפיים", "גב רחב"]
                ),
                Exercise(
                    nameHe: "Negative Pull-Up",
                    nameEn: "Negative Pull-Up",
                    sets: 4, repsOrTime: "3-5",
                    restSeconds: 90,
                    descriptionHe: "קפצי מעל הבר (או עמדי על כיסא), אחזי בו במצב שכיבות משיכה כפוף. הורידי עצמך לאיטי מאוד (5-7 שניות). זה יבנה את הכוח לשלייה מלאה!",
                    descriptionEn: "Jump above the bar (or stand on chair), hold in chin-up position. Lower yourself very slowly (5-7 seconds). This builds pull-up strength!",
                    targetMuscles: ["גב רחב", "ביצפס", "כתפיים"]
                ),
                Exercise(
                    nameHe: "Inverted Row רגליים גבוהות",
                    nameEn: "Elevated Feet Inverted Row",
                    sets: 3, repsOrTime: "8",
                    descriptionHe: "Inverted row אך הנחי רגליים על כיסא. מאתגר הרבה יותר!",
                    descriptionEn: "Inverted row but place feet on a chair. Much more challenging!",
                    targetMuscles: ["גב", "ביצפס"]
                ),
                Exercise(
                    nameHe: "סקוואט + Overhead Press (בקבוקי מים)",
                    nameEn: "Squat + Overhead Press (water bottles)",
                    sets: 3, repsOrTime: "12",
                    descriptionHe: "סקוואט עם 2 בקבוקי מים מלאים (1.5 ליטר כל אחד). בעלייה – הרימי ידיים מעל הראש. קוֹמְפּאוּנד מעולה!",
                    descriptionEn: "Squat holding 2 full water bottles (1.5L each). As you rise – press arms overhead. Great compound movement!",
                    targetMuscles: ["ירכיים", "ישבן", "כתפיים"]
                )
            ],
            warmupNote: "5 דקות + 3 תלייה קצרה (10 שניות) להכנת ידיים",
            cooldownNote: "מתיחות ידיים, גב, ירכיים"
        ),
        TrainingDay(
            week: 9, day: 3,
            titleHe: "שבוע 9 יום 3 – סיבולת גבוהה",
            titleEn: "Week 9 Day 3 – High Intensity Endurance",
            focusHe: "כל הגוף, קצב גבוה",
            focusEn: "Full Body, High Pace",
            exercises: [
                Exercise(
                    nameHe: "Tabata: 8 × 20 שניות עבודה + 10 שניות מנוחה",
                    nameEn: "Tabata: 8 × 20s work + 10s rest",
                    sets: 2, repsOrTime: "4 דקות כל סבב",
                    restSeconds: 120,
                    descriptionHe: "סבב 1: שכיבות שמיכה (מלאות או ברכיים) | סבב 2: סקוואט קפיצה (או סקוואט). 8 אינטרוולים × 20 שניות עבודה + 10 שניות מנוחה. 2 דקות בין סבבים.",
                    descriptionEn: "Round 1: Push-ups (full or knee) | Round 2: Jump squats (or regular squats). 8 intervals × 20s work + 10s rest. 2 min between rounds.",
                    targetMuscles: ["כל הגוף", "לב-ריאה"]
                ),
                Exercise(
                    nameHe: "ליבה מלאה 3 × 3",
                    nameEn: "Core Tri-Set",
                    sets: 3, repsOrTime: "30 שניות כל תרגיל",
                    restSeconds: 60,
                    descriptionHe: "3 תרגילי ליבה ברצף: (1) פלאנק 30 שניות → (2) פלאנק צד שמאל 30 שניות → (3) פלאנק צד ימין 30 שניות. ללא מנוחה בין תרגילים!",
                    descriptionEn: "3 core exercises back-to-back: (1) Plank 30s → (2) Left side plank 30s → (3) Right side plank 30s. No rest between exercises!",
                    targetMuscles: ["ליבה מלאה"]
                )
            ],
            warmupNote: "10 דקות חימום אינטנסיבי",
            cooldownNote: "10-12 דקות מתיחות + נשימות. עשית משהו מדהים השבוע!"
        )
    ]

    static let week10 = week9.map { day in
        TrainingDay(week: 10, day: day.day,
                    titleHe: day.titleHe.replacingOccurrences(of: "שבוע 9", with: "שבוע 10"),
                    titleEn: day.titleEn.replacingOccurrences(of: "Week 9", with: "Week 10"),
                    focusHe: day.focusHe, focusEn: day.focusEn,
                    exercises: day.exercises, warmupNote: day.warmupNote, cooldownNote: day.cooldownNote)
    }

    static let week11 = week9.map { day in
        TrainingDay(week: 11, day: day.day,
                    titleHe: day.titleHe.replacingOccurrences(of: "שבוע 9", with: "שבוע 11"),
                    titleEn: day.titleEn.replacingOccurrences(of: "Week 9", with: "Week 11"),
                    focusHe: day.focusHe, focusEn: day.focusEn,
                    exercises: day.exercises.map { ex in
                        Exercise(nameHe: ex.nameHe, nameEn: ex.nameEn,
                                 sets: min(ex.sets + 1, 5), repsOrTime: ex.repsOrTime,
                                 restSeconds: ex.restSeconds, descriptionHe: ex.descriptionHe,
                                 descriptionEn: ex.descriptionEn, targetMuscles: ex.targetMuscles)
                    },
                    warmupNote: day.warmupNote, cooldownNote: day.cooldownNote)
    }

    static let week12 = week11.map { day in
        TrainingDay(week: 12, day: day.day,
                    titleHe: "\(day.titleHe.replacingOccurrences(of: "שבוע 11", with: "שבוע 12")) – שבוע הסיום!",
                    titleEn: "\(day.titleEn.replacingOccurrences(of: "Week 11", with: "Week 12")) – Final Week!",
                    focusHe: day.focusHe, focusEn: day.focusEn,
                    exercises: day.exercises, warmupNote: day.warmupNote, cooldownNote: day.cooldownNote)
    }
}
