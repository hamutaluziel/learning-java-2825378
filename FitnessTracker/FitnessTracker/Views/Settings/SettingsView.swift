import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    @EnvironmentObject var healthKit: HealthKitService
    @State private var profile: UserProfile = AppSettings.shared.profile
    @State private var showSaved = false
    @State private var showAPIKeyInfo = false

    var body: some View {
        NavigationStack {
            Form {
                Section(L.userProfile) {
                    HStack {
                        Label(L.weight, systemImage: "scalemass.fill")
                        Spacer()
                        TextField("80", value: $profile.weightKg, format: .number.precision(.fractionLength(1)))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("ק\"ג").foregroundStyle(.secondary)
                    }
                    HStack {
                        Label(L.height, systemImage: "ruler")
                        Spacer()
                        TextField("168", value: $profile.heightCm, format: .number.precision(.fractionLength(0)))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("ס\"מ").foregroundStyle(.secondary)
                    }
                    HStack {
                        Label(L.age, systemImage: "birthday.cake")
                        Spacer()
                        TextField("46", value: $profile.age, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("שנים").foregroundStyle(.secondary)
                    }
                    Picker(L.gender, selection: $profile.gender) {
                        ForEach(UserProfile.Gender.allCases, id: \.self) { g in
                            Text(g.localizedName).tag(g)
                        }
                    }
                }

                Section("ניתוח תזונה") {
                    HStack {
                        Label(L.goalCalories, systemImage: "flame.fill")
                        Spacer()
                        TextField("2100", value: $profile.goalCalories, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("kcal").foregroundStyle(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("חישוב אוטומטי מהפרופיל שלך:")
                            .font(.caption).foregroundStyle(.secondary)
                        let calc = calculateRecommended()
                        Text("BMR: \(Int(calc.bmr)) · TDEE: \(Int(calc.tdee)) · מומלץ לירידה: \(Int(calc.tdee * 0.85))")
                            .font(.caption2).foregroundStyle(.orange)
                    }
                }

                Section {
                    HStack {
                        Label(L.claudeAPIKeyTitle, systemImage: "key.fill")
                        Button {
                            showAPIKeyInfo = true
                        } label: {
                            Image(systemName: "questionmark.circle")
                                .foregroundStyle(.orange)
                        }
                    }
                    SecureField(L.claudeAPIKeyHint, text: $profile.claudeAPIKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } header: {
                    Text("Claude AI")
                } footer: {
                    Text("המפתח נשמר מאובטח במכשיר בלבד ואינו נשלח שום מקום מלבד Anthropic.")
                        .font(.caption2)
                }

                Section(L.language) {
                    Picker(L.language, selection: $profile.language) {
                        ForEach(UserProfile.AppLanguage.allCases, id: \.self) { lang in
                            Text(lang.localizedName).tag(lang)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Apple Health") {
                    HStack {
                        Image(systemName: healthKit.isAuthorized ? "heart.fill" : "heart.slash")
                            .foregroundStyle(healthKit.isAuthorized ? .red : .gray)
                        Text(healthKit.isAuthorized ? "מחובר ✓" : "לא מחובר")
                        Spacer()
                        if !healthKit.isAuthorized {
                            Button(L.connectHealthApp) {
                                Task { await healthKit.requestAuthorization() }
                            }
                            .font(.caption).foregroundStyle(.red)
                        }
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Label("סנכרון Runna", systemImage: "arrow.triangle.2.circlepath")
                            .font(.subheadline).fontWeight(.medium)
                        Text(L.runnaIntegrationNote)
                            .font(.caption2).foregroundStyle(.secondary)
                    }
                }

                Section("נתוני הבריאות") {
                    statRow(label: "BMI", value: String(format: "%.1f – %@", profile.bmi, profile.bmiCategory))
                    statRow(label: "חלבון יומי מומלץ", value: "\(Int(profile.dailyProteinTarget))g")
                    statRow(label: "פחמימות יומיות", value: "\(Int(profile.dailyCarbTarget))g")
                    statRow(label: "שומן יומי", value: "\(Int(profile.dailyFatTarget))g")
                }

                Section {
                    Button {
                        settings.profile = profile
                        showSaved = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSaved = false
                        }
                    } label: {
                        HStack {
                            Spacer()
                            if showSaved {
                                Label(L.profileSaved, systemImage: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else {
                                Text(L.saveSettings)
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .tint(.orange)
                }
            }
            .navigationTitle(L.settings)
            .onAppear { profile = settings.profile }
            .alert("מפתח Claude API", isPresented: $showAPIKeyInfo) {
                Button(L.ok) {}
            } message: {
                Text("קבלי מפתח API חינמי בכתובת console.anthropic.com\n\nהמפתח מאפשר לאפליקציה לנתח את הארוחות שלך ולתת לך משוב אישי.")
            }
        }
    }

    private func calculateRecommended() -> UserProfile {
        var p = profile
        p.weightKg = profile.weightKg
        p.heightCm = profile.heightCm
        p.age = profile.age
        return p
    }

    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value).fontWeight(.medium)
        }
    }
}
