import SwiftUI
import SwiftData

@main
struct TimeCapsuleApp: App {
    @StateObject private var viewModel = TimeCapsuleViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TimeCapsule.self,
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        NotificationManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .modelContainer(sharedModelContainer)
                .onAppear {
                    viewModel.setModelContext(sharedModelContainer.mainContext)
                }
                .preferredColorScheme(nil)
        }
    }
}
