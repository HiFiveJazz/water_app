import SwiftUI
import SplineRuntime

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Onboard3DView()
                    .frame(height: 589)
                    .ignoresSafeArea(edges: .top)
                
                VStack(spacing: 21) {
                    Text("Welcome!")
                        .font(.title.bold())

                    Text("Stay up to date with all your hydration goals!")
                       
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center) // Centers the text across lines
                        .lineLimit(nil) // Ensures it wraps to as many lines as needed

                    NavigationLink(destination: GetStarted()) {
                        Text("Get Started")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity) // Ensures text uses all available space
            }
        }
    }
}

struct Onboard3DView: View {
    var body: some View {
            // fetching from cloud
            let url = URL(string: "https://build.spline.design/6fr-fOnASo1PFurVGexr/scene.splineswift")!

            // fetching from local
            // let url = Bundle.main.url(forResource: "scene", withExtension: "splineswift")!

            SplineView(sceneFileURL: url).ignoresSafeArea(.all)
    }
}


struct GetStarted: View {
    @State private var bodyweight = ""
    @State private var weightUnit = "lbs"  // Default to pounds
    @State private var birthdate = Calendar.current.date(from: DateComponents(year: 2004, month: 11, day: 28)) ?? Date()
    @State private var exerciseHours = 0.0  // Initialize to 0 hours
    @State private var showBodyweightExplanation = false
    @State private var showBirthdateExplanation = false
    @State private var showExerciseExplanation = false

    let weightUnits = ["lbs", "kg"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Get Started")
                .font(.largeTitle)
                .bold()

            // Bodyweight Input
            HStack {
                TextField("Enter your bodyweight", text: $bodyweight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 220)
                Button(action: {
                    showBodyweightExplanation = true
                }) {
                    Text("?")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 20, height: 20)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .popover(isPresented: $showBodyweightExplanation) {
                    VStack(alignment: .center, spacing: 5) {
                        Text("Why We Need Your Bodyweight")
                            .font(.headline)
                        Text("This app asks for your body weight because it's an essential factor in calculating your daily water needs accurately. Water requirements aren’t the same for everyone; they vary depending on individual characteristics like body size. When your body weight is factored in, the app can provide you with a tailored water intake recommendation that better aligns with your unique hydration needs. This helps ensure that your cells, tissues, and organs get enough water to perform crucial functions like nutrient transport, temperature regulation, and waste removal efficiently. By knowing your body weight, the app can also adjust your water intake based on your metabolism and daily activity level. Typically, a larger body mass requires more energy, which means your body will naturally produce more metabolic waste and heat. These factors increase the amount of water you need each day, so having accurate weight information helps the app personalize a recommendation that keeps you optimally hydrated and supports your overall well-being.Additionally, your body weight plays a role in kidney function and how effectively your body manages fluid balance. For example, larger body mass means your kidneys need to filter more blood to maintain fluid and electrolyte levels, which increases your water requirements. By using your weight in its calculation, the app can help you maintain a healthy balance, reducing the risk of dehydration and supporting optimal kidney function.")
                            .font(.body)
                        Button("Got it!") {
                            showBodyweightExplanation = false
                        }
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .frame(width: 350)
                }

                Picker("Unit", selection: $weightUnit) {
                    ForEach(weightUnits, id: \.self) { unit in
                        Text(unit)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 75)
            }
            .padding(.horizontal)

            // Birthdate Input
            HStack {
                Text("Birthdate")
                Button(action: {
                    showBirthdateExplanation = true
                }) {
                    Text("?")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 20, height: 20)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .popover(isPresented: $showBirthdateExplanation) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Why We Need Your Birthdate")
                            .font(.headline)
                        Text("Providing your birthdate helps us calculate your age for personalized insights.")
                            .font(.body)
                        Button("Got it!") {
                            showBirthdateExplanation = false
                        }
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .frame(width: 250)
                }

                DatePicker("", selection: $birthdate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
            }
            .padding(.horizontal)

            // Exercise per Day Input
            HStack {
                Text("Exercise per day: \(formattedExerciseTime)")
                    .frame(width: 150, alignment: .leading)
                
                Button(action: {
                    showExerciseExplanation = true
                }) {
                    Text("?")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 20, height: 20)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .popover(isPresented: $showExerciseExplanation) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Why We Need Your Exercise Information")
                            .font(.headline)
                        Text("This helps us track your activity level and give recommendations based on it.")
                            .font(.body)
                        Button("Got it!") {
                            showExerciseExplanation = false
                        }
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .frame(width: 250)
                }

                Slider(value: $exerciseHours, in: 0...12, step: 0.5)
            }
            .padding(.horizontal)

            NavigationLink(
                destination: UserDataView(
                    bodyweight: Double(bodyweight) ?? 0.0,
                    weightUnit: weightUnit,
                    age: calculateAge(from: birthdate),
                    exerciseTime: formattedExerciseTime
                )
            ) {
                Text("Continue")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
    }

    var formattedExerciseTime: String {
        let hours = Int(exerciseHours)
        let minutes = Int((exerciseHours - Double(hours)) * 60)
        return "\(hours)h \(minutes)m"
    }

    func calculateAge(from birthdate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: Date())
        return ageComponents.year ?? 0
    }
}

struct UserDataView: View {
    let bodyweight: Double
    let weightUnit: String
    let age: Int
    let exerciseTime: String

    var body: some View {
        VStack(spacing: 20) {
            Text("User Data")
                .font(.title)
                .bold()

            Text("Weight: \(String(format: "%.1f", bodyweight)) \(weightUnit)")
            Text("Age: \(age) years")
            Text("Exercise per day: \(exerciseTime)")

            Spacer()
        }
        .padding()
    }
}

struct UserData {
    let bodyweight: Double
    let weightUnit: String
    let age: Int
    let exerciseMinutes: Int
}

#Preview {
    ContentView()
}
