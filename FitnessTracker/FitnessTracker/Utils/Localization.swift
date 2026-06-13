import Foundation

// L is the localization namespace. All user-facing strings go through here.
// Since the app is bilingual, we check AppSettings for the current language.
enum L {
    // MARK: - Tab names
    static var dashboard: String { s("לוח בקרה", "Dashboard") }
    static var workouts: String { s("אימונים", "Workouts") }
    static var nutrition: String { s("תזונה", "Nutrition") }
    static var training: String { s("אימון", "Training") }
    static var settings: String { s("הגדרות", "Settings") }

    // MARK: - Dashboard
    static var todayActivity: String { s("פעילות היום", "Today's Activity") }
    static var steps: String { s("צעדים", "Steps") }
    static var distance: String { s("מרחק", "Distance") }
    static var calories: String { s("קלוריות", "Calories") }
    static var activeCalories: String { s("קלוריות פעילות", "Active Calories") }
    static var exerciseMinutes: String { s("דקות אימון", "Exercise Minutes") }
    static var weeklyProgress: String { s("התקדמות שבועית", "Weekly Progress") }
    static var connectHealth: String { s("חבר Apple Health", "Connect Apple Health") }
    static var healthPermissionNeeded: String { s("נדרשת הרשאה ל-Apple Health", "Apple Health permission needed") }
    static var goodMorning: String { s("בוקר טוב", "Good morning") }
    static var goodAfternoon: String { s("צהריים טובים", "Good afternoon") }
    static var goodEvening: String { s("ערב טוב", "Good evening") }

    // MARK: - Workouts
    static var recentWorkouts: String { s("אימונים אחרונים", "Recent Workouts") }
    static var noWorkouts: String { s("לא נמצאו אימונים", "No workouts found") }
    static var duration: String { s("משך", "Duration") }
    static var pace: String { s("קצב", "Pace") }
    static var heartRate: String { s("דופק", "Heart Rate") }
    static var source: String { s("מקור", "Source") }
    static var running: String { s("ריצה", "Running") }
    static var walking: String { s("הליכה", "Walking") }
    static var cycling: String { s("רכיבה", "Cycling") }
    static var swimming: String { s("שחייה", "Swimming") }
    static var strengthTraining: String { s("אימון כוח", "Strength Training") }
    static var workout: String { s("אימון", "Workout") }

    // MARK: - Nutrition
    static var logFood: String { s("רשום ארוחה", "Log Food") }
    static var whatDidYouEat: String { s("מה אכלת?", "What did you eat?") }
    static var mealType: String { s("סוג ארוחה", "Meal Type") }
    static var breakfast: String { s("ארוחת בוקר", "Breakfast") }
    static var lunch: String { s("ארוחת צהריים", "Lunch") }
    static var dinner: String { s("ארוחת ערב", "Dinner") }
    static var snack: String { s("חטיף", "Snack") }
    static var analyzeFood: String { s("נתח עם AI", "Analyze with AI") }
    static var analyzing: String { s("מנתח...", "Analyzing...") }
    static var todaysSummary: String { s("סיכום היום", "Today's Summary") }
    static var protein: String { s("חלבון", "Protein") }
    static var carbs: String { s("פחמימות", "Carbs") }
    static var fat: String { s("שומן", "Fat") }
    static var target: String { s("יעד", "Target") }
    static var aiFeedback: String { s("משוב AI", "AI Feedback") }
    static var suggestions: String { s("המלצות", "Suggestions") }
    static var dailyInsight: String { s("תובנה יומית", "Daily Insight") }
    static var noFoodToday: String { s("לא רשמת ארוחות היום עדיין", "No meals logged today yet") }
    static var foodDescription: String { s("תאר מה אכלת (לדוגמה: קצפת עוף עם אורז ומנת ירקות)", "Describe what you ate (e.g.: chicken breast with rice and vegetables)") }

    // MARK: - Calisthenics
    static var yourProgram: String { s("התוכנית שלך", "Your Program") }
    static var currentWeek: String { s("שבוע נוכחי", "Current Week") }
    static var nextSession: String { s("האימון הבא", "Next Session") }
    static var startWorkout: String { s("התחל אימון", "Start Workout") }
    static var completeWorkout: String { s("סיים אימון", "Complete Workout") }
    static var sets: String { s("סטים", "Sets") }
    static var reps: String { s("חזרות", "Reps") }
    static var rest: String { s("מנוחה", "Rest") }
    static var seconds: String { s("שניות", "seconds") }
    static var warmup: String { s("חימום", "Warmup") }
    static var cooldown: String { s("שחרור", "Cooldown") }
    static var weekOf12: String { s("שבוע %d מתוך 12", "Week %d of 12") }
    static var programProgress: String { s("התקדמות בתוכנית", "Program Progress") }
    static var sessionHistory: String { s("היסטוריית אימונים", "Session History") }
    static var difficultRating: String { s("דירוג קושי", "Difficulty Rating") }
    static var notes: String { s("הערות", "Notes") }
    static var holyMolly: String { s("כל הכבוד! 🔥", "Amazing! 🔥") }

    // MARK: - Settings
    static var userProfile: String { s("פרופיל משתמש", "User Profile") }
    static var weight: String { s("משקל (ק\"ג)", "Weight (kg)") }
    static var height: String { s("גובה (ס\"מ)", "Height (cm)") }
    static var age: String { s("גיל", "Age") }
    static var gender: String { s("מין", "Gender") }
    static var female: String { s("נקבה", "Female") }
    static var male: String { s("זכר", "Male") }
    static var goalCalories: String { s("קלוריות יעד ליום", "Daily Calorie Goal") }
    static var claudeAPIKeyTitle: String { s("מפתח API של Claude", "Claude API Key") }
    static var claudeAPIKeyHint: String { s("sk-ant-...", "sk-ant-...") }
    static var language: String { s("שפה", "Language") }
    static var connectHealthApp: String { s("חבר Apple Health", "Connect Apple Health") }
    static var runnaIntegrationNote: String { s("כדי לסנכרן Runna: פתחי את Runna → הגדרות → Connections → Apple Health → הפעילי", "To sync Runna: open Runna → Settings → Connections → Apple Health → Enable") }
    static var saveSettings: String { s("שמור הגדרות", "Save Settings") }
    static var profileSaved: String { s("הפרופיל נשמר ✓", "Profile saved ✓") }
    static var bmi: String { s("BMI", "BMI") }
    static var normalWeight: String { s("משקל תקין", "Normal weight") }
    static var overweight: String { s("עודף משקל", "Overweight") }
    static var underweight: String { s("תת משקל", "Underweight") }
    static var obese: String { s("השמנה", "Obese") }

    // MARK: - Errors
    static var healthNotAvailable: String { s("Apple Health אינו זמין במכשיר זה", "Apple Health is not available on this device") }
    static var noAPIKey: String { s("הזיני מפתח Claude API בהגדרות", "Enter your Claude API key in Settings") }
    static var networkError: String { s("שגיאת רשת – נסי שוב", "Network error – please retry") }
    static var parseError: String { s("שגיאה בעיבוד תגובת AI", "Error parsing AI response") }
    static var error: String { s("שגיאה", "Error") }
    static var retry: String { s("נסה שוב", "Retry") }
    static var ok: String { s("אוקי", "OK") }
    static var cancel: String { s("ביטול", "Cancel") }
    static var save: String { s("שמור", "Save") }
    static var done: String { s("סיום", "Done") }
    static var add: String { s("הוסף", "Add") }
    static var delete: String { s("מחק", "Delete") }

    // MARK: - Helper
    private static func s(_ hebrew: String, _ english: String) -> String {
        AppSettings.shared.isHebrew ? hebrew : english
    }
}
