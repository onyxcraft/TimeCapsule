import Foundation
import SwiftData
import SwiftUI

@MainActor
class TimeCapsuleViewModel: ObservableObject {
    @Published var capsules: [TimeCapsule] = []
    @Published var showingCreateView = false
    @Published var selectedCapsule: TimeCapsule?
    @Published var showingUnlockAnimation = false

    private var modelContext: ModelContext?
    private let notificationManager = NotificationManager.shared

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        fetchCapsules()
    }

    func fetchCapsules() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<TimeCapsule>(
            sortBy: [SortDescriptor(\.unlockDate, order: .forward)]
        )

        do {
            capsules = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch capsules: \(error)")
        }
    }

    func createCapsule(title: String, message: String, unlockDate: Date, images: [UIImage]) {
        guard let context = modelContext else { return }

        let imageData = images.compactMap { image in
            image.jpegData(compressionQuality: 0.8)
        }

        let capsule = TimeCapsule(
            title: title,
            message: message,
            unlockDate: unlockDate,
            imageData: imageData
        )

        context.insert(capsule)

        do {
            try context.save()
            scheduleNotification(for: capsule)
            fetchCapsules()
        } catch {
            print("Failed to save capsule: \(error)")
        }
    }

    func unlockCapsule(_ capsule: TimeCapsule) {
        guard capsule.canUnlock else { return }

        capsule.unlock()

        if let context = modelContext {
            do {
                try context.save()
                fetchCapsules()
            } catch {
                print("Failed to unlock capsule: \(error)")
            }
        }

        if let identifier = capsule.notificationIdentifier {
            notificationManager.cancelNotification(identifier: identifier)
        }
    }

    func relockCapsule(_ capsule: TimeCapsule, until newDate: Date) {
        guard !capsule.isLocked else { return }

        capsule.relock(until: newDate)

        if let context = modelContext {
            do {
                try context.save()
                scheduleNotification(for: capsule)
                fetchCapsules()
            } catch {
                print("Failed to relock capsule: \(error)")
            }
        }
    }

    func deleteCapsule(_ capsule: TimeCapsule) {
        guard let context = modelContext else { return }

        if let identifier = capsule.notificationIdentifier {
            notificationManager.cancelNotification(identifier: identifier)
        }

        context.delete(capsule)

        do {
            try context.save()
            fetchCapsules()
        } catch {
            print("Failed to delete capsule: \(error)")
        }
    }

    private func scheduleNotification(for capsule: TimeCapsule) {
        let identifier = notificationManager.scheduleNotification(
            for: capsule.unlockDate,
            title: "Time Capsule Unlocked!",
            body: "Your letter \"\(capsule.title)\" is ready to open."
        )
        capsule.notificationIdentifier = identifier
    }

    var lockedCapsules: [TimeCapsule] {
        capsules.filter { $0.isLocked && !$0.canUnlock }
    }

    var unlockedCapsules: [TimeCapsule] {
        capsules.filter { !$0.isLocked || $0.canUnlock }
    }
}
