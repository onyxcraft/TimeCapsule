import Foundation
import SwiftData

@Model
final class TimeCapsule {
    var id: UUID
    var title: String
    var message: String
    var createdDate: Date
    var unlockDate: Date
    var isLocked: Bool
    var imageData: [Data]
    var notificationIdentifier: String?

    init(
        title: String,
        message: String,
        unlockDate: Date,
        imageData: [Data] = []
    ) {
        self.id = UUID()
        self.title = title
        self.message = message
        self.createdDate = Date()
        self.unlockDate = unlockDate
        self.isLocked = true
        self.imageData = imageData
        self.notificationIdentifier = nil
    }

    var isUnlocked: Bool {
        return Date() >= unlockDate && !isLocked
    }

    var canUnlock: Bool {
        return Date() >= unlockDate
    }

    var daysUntilUnlock: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: unlockDate)
        return max(0, components.day ?? 0)
    }

    var yearsUntilUnlock: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: Date(), to: unlockDate)
        return max(0, components.year ?? 0)
    }

    func unlock() {
        isLocked = false
    }

    func relock(until newUnlockDate: Date) {
        self.unlockDate = newUnlockDate
        self.isLocked = true
    }
}
