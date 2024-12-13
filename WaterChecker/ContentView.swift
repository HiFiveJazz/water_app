import SwiftUI
import SplineRuntime

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Onboard3DView()
                    .frame(height: 660)
                    .ignoresSafeArea(edges: .bottom)

                VStack(spacing: 20) {
                    Text("Welcome!")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .padding(.top, 15)
                        .padding(.bottom, -5)

                    Text("Stay up to date with all your hydration goals!")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 0)
                        .padding(.bottom, 0)

                    NavigationLink(value: "GetStarted") {
                        Text("Get Started")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 100)
                .padding(.top, 20)
                .background(Color.black)
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "GetStarted" {
                    GetStarted()
                }
            }
        }
    }
}


struct Onboard3DView: View {
    var body: some View {
        let url = URL(string: "https://build.spline.design/6fr-fOnASo1PFurVGexr/scene.splineswift")!

        SplineView(sceneFileURL: url).ignoresSafeArea(.all)
    }
}

// A reusable component for each question
struct GetStarted: View {
    @State private var bodyweight = ""
    @State private var weightUnit = "lbs"
    @State private var birthdate = Calendar.current.date(from: DateComponents(year: 2004, month: 11, day: 28)) ?? Date()
    @State private var wakeUpTime = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var sleepTime = Calendar.current.date(bySettingHour: 4, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var exerciseHours = 0.0
    @State private var gender = "Male"
    @State private var showError: Bool = false
    @State private var navigateToNextPage: Bool = false

    let weightUnits = ["lbs", "kg"]
    let genders = ["Male", "Female", "Other"]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Get Started")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        
                        // Gender Input
                        QuestionRow(
                            title: "Gender",
                            explanation: "Your gender helps us refine hydration recommendations."
                        ) {
                            Picker("Select Gender", selection: $gender) {
                                ForEach(genders, id: \.self) { gender in
                                    Text(gender)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .foregroundColor(.white)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                        }

                        // Bodyweight Input
                        QuestionRow(
                            title: "Bodyweight",
                            explanation: "Your bodyweight helps us calculate personalized hydration goals."
                        ) {
                            HStack {
                                TextField("Enter your bodyweight", text: $bodyweight)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(.black)
                                    .background(Color.black.opacity(0.9))
                                    .cornerRadius(8)

                                Picker("Unit", selection: $weightUnit) {
                                    ForEach(weightUnits, id: \.self) { unit in
                                        Text(unit)
                                            .foregroundColor(.white)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .frame(width: 100)
                                .environment(\.colorScheme, .dark)
                            }
                        }

                        // Wake-Up Time Input
                        QuestionRow(
                            title: "Wake-Up Time",
                            explanation: "Knowing your wake-up time helps us optimize your hydration schedule."
                        ) {
                            DatePicker("", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .accentColor(.red)
                                .environment(\.colorScheme, .dark)
                        }

                        // Sleep Time Input
                        QuestionRow(
                            title: "Sleep Time",
                            explanation: "Knowing your sleep time helps us avoid scheduling reminders during your rest."
                        ) {
                            DatePicker("", selection: $sleepTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .accentColor(.red)
                                .environment(\.colorScheme, .dark)
                        }

                        // Birthdate Input
                        QuestionRow(
                            title: "Birthdate",
                            explanation: "Providing your birthdate helps us calculate your age for personalized insights."
                        ) {
                            DatePicker("", selection: $birthdate, displayedComponents: .date)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .datePickerStyle(WheelDatePickerStyle())
                                .foregroundColor(.white)
                                .accentColor(.red)
                                .environment(\.colorScheme, .dark)
                        }

                        // Exercise Input
                        QuestionRow(
                            title: "Exercise per Day",
                            explanation: "Exercise impacts hydration needs; this data helps us personalize recommendations."
                        ) {
                            VStack {
                                Slider(value: $exerciseHours, in: 0...12, step: 0.5)
                                    .accentColor(.red)
                                Text("\(formattedExerciseTime)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.visible) // Makes the scrollbar always visible
                .background(Color.black.edgesIgnoringSafeArea(.all))

                // Continue Button (Navigates to UserDataView)
                VStack(spacing: 0) {
                    Button(action: {
                        if wakeUpTime == sleepTime {
                            showError = true
                        } else {
                            showError = false
                            navigateToNextPage = true
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    if showError {
                        Text("Wake-Up Time and Sleep Time cannot be the same!")
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.top, 10)
                    }

                    NavigationLink(
                        destination: UserDataView(
                            bodyweight: Double(bodyweight) ?? 0.0,
                            weightUnit: weightUnit,
                            birthdate: birthdate,
                            wakeUpTime: wakeUpTime,
                            sleepTime: sleepTime,
                            exerciseTime: formattedExerciseTime,
                            gender: gender
                        ),
                        isActive: $navigateToNextPage
                    ) {
                        EmptyView()
                    }
                }
                .background(Color.black) // Ensures sticky area matches the black theme
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }

    var formattedExerciseTime: String {
        let hours = Int(exerciseHours)
        let minutes = Int((exerciseHours - Double(hours)) * 60)
        return "\(hours)h \(minutes)m"
    }
}



struct QuestionRow<Content: View>: View {
    let title: String
    let explanation: String
    let content: Content

    @State private var showExplanation: Bool = false

    init(title: String, explanation: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.explanation = explanation
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Button(action: { showExplanation = true }) {
                    Text("?")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 20, height: 20)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .popover(isPresented: $showExplanation) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Why We Need This")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(explanation)
                            .font(.body)
                            .foregroundColor(.white)
                        Button("Got it!") {
                            showExplanation = false
                        }
                        .padding(.top)
                        .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.black.edgesIgnoringSafeArea(.all)) // Set entire popover background to black
                    .cornerRadius(10)
                }

                Spacer()
            }

            HStack {
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct UserDataView: View {
    let bodyweight: Double
    let weightUnit: String
    let birthdate: Date
    let wakeUpTime: Date
    let sleepTime: Date
    let exerciseTime: String
    let gender: String

    @State private var navigateToWaterSettings = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("User Data Summary")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    // Gender Data
                    DataRow(
                        title: "Gender",
                        content: gender
                    )

                    // Bodyweight Data
                    DataRow(
                        title: "Bodyweight",
                        content: "\(String(format: "%.1f", bodyweight)) \(weightUnit)"
                    )

                    // Birthdate Data
                    DataRow(
                        title: "Birth Date",
                        content: birthdate.formatted(date: .long, time: .omitted)
                    )

                    // Wake-Up Time Data
                    DataRow(
                        title: "Wake-Up Time",
                        content: wakeUpTime.formatted(date: .omitted, time: .shortened)
                    )

                    // Sleep Time Data
                    DataRow(
                        title: "Sleep Time",
                        content: sleepTime.formatted(date: .omitted, time: .shortened)
                    )

                    // Exercise Time Data
                    DataRow(
                        title: "Exercise per Day",
                        content: exerciseTime
                    )
                }
                .padding()
            }
            .scrollIndicators(.visible)
            .background(Color.black.edgesIgnoringSafeArea(.all))

            VStack(spacing: 0) {
                // Confirm Button for navigating to WaterSettingsView
                NavigationLink(destination: WaterSettingsView()
                                .navigationBarBackButtonHidden(true),
                               isActive: $navigateToWaterSettings) {
                    EmptyView()
                }

                Button(action: {
                    navigateToWaterSettings = true
                }) {
                    Text("Confirm")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .background(Color.black)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(false) // Allow back button for GetStarted
    }
}

struct DataRow: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 5)

            HStack {
                Text(content)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct WaterSettingsView: View {
    @State private var sittings: Int = 8
    @State private var notificationsEnabled: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Set Your Hydration Goals")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                Text("How many times a day would you like to drink water?")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                // Slider for sittings
                VStack {
                    Slider(value: Binding(get: {
                        Double(self.sittings)
                    }, set: { newValue in
                        self.sittings = Int(newValue)
                    }), in: 4...12, step: 1)
                    Text("\(sittings) sittings")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding()

                // Enable notifications button
                Button(action: {
                    requestNotificationPermission()
                }) {
                    Text(notificationsEnabled ? "Notifications Enabled" : "Enable Notifications")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(notificationsEnabled ? Color.green : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding()

                Spacer()

                // Finish button to navigate back or move to another page
                NavigationLink(destination: ContentView()) {
                    Text("Finish")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .navigationBarBackButtonHidden(true)
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.notificationsEnabled = true
            } else {
                print("Notification permission denied.")
            }
        }
    }
}


#Preview {
    ContentView()
}

