# TimeCapsule

Write letters to your future self.

## Overview

TimeCapsule is an iOS app that allows you to write letters to your future self. Create heartfelt messages, attach photos, and lock them away until a specific date in the future. When the time comes, receive a push notification and unlock your capsule to read what you wrote to yourself.

## Features

- **Write Letters**: Compose meaningful messages to your future self with rich text support
- **Photo Attachments**: Add up to 10 photos to each time capsule
- **Lock Until Future**: Set unlock dates from 1 month to 10 years in the future
- **Secure Lock**: Capsules cannot be opened before their unlock date
- **Push Notifications**: Get notified when a capsule is ready to unlock
- **Beautiful Animations**:
  - Envelope sealing animation when creating a capsule
  - Unlock animation when opening a capsule
- **Gallery View**: Browse all your locked and unlocked capsules
- **Re-lock Feature**: Lock an opened capsule again for another period
- **PDF Export**: Export unlocked letters as PDF documents to share or save
- **iCloud Backup**: Your capsules are automatically backed up to iCloud
- **Dark Mode**: Full support for iOS dark mode

## Requirements

- iOS 17.0 or later
- iPhone or iPad
- iCloud account (for backup)

## Installation

1. Open `TimeCapsule.xcodeproj` in Xcode 15 or later
2. Select your development team in the project settings
3. Build and run on your device or simulator

## Architecture

TimeCapsule follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: SwiftData models for data persistence
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic and state management
- **Services**:
  - NotificationManager: Handle push notifications
  - PDFGenerator: Generate PDF exports

### Tech Stack

- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Apple's new data persistence framework
- **UserNotifications**: Local push notifications
- **PhotosUI**: Photo library access
- **PDFKit**: PDF generation and export
- **iCloud**: CloudKit integration for automatic backup

## Project Structure

```
TimeCapsule/
├── Models/
│   └── TimeCapsule.swift
├── ViewModels/
│   └── TimeCapsuleViewModel.swift
├── Views/
│   ├── CreateCapsuleView.swift
│   ├── CapsuleGalleryView.swift
│   ├── CapsuleDetailView.swift
│   ├── EnvelopeAnimationView.swift
│   └── UnlockAnimationView.swift
├── Services/
│   ├── NotificationManager.swift
│   └── PDFGenerator.swift
├── Utilities/
│   └── ImagePicker.swift
├── Assets.xcassets/
├── Info.plist
└── TimeCapsule.entitlements
```

## Usage

### Creating a Time Capsule

1. Tap the "Create" tab or the "Create Time Capsule" button
2. Enter a title and write your letter
3. (Optional) Add photos from your photo library
4. Select an unlock date using the date picker or quick select buttons
5. Tap "Seal Time Capsule" to save and lock it

### Viewing Capsules

- Navigate to the "Gallery" tab to see all your capsules
- Locked capsules show days remaining until unlock
- Ready-to-unlock capsules are highlighted in green
- Unlocked capsules can be viewed anytime

### Unlocking a Capsule

1. Tap on a capsule that's ready to unlock
2. Tap "Unlock Now" to trigger the unlock animation
3. View your letter and photos
4. Export as PDF or re-lock for another period

### Re-locking a Capsule

1. Open an unlocked capsule
2. Tap the menu button (•••) and select "Re-lock Capsule"
3. Choose a new unlock date
4. Confirm to re-lock

### Exporting to PDF

1. Open an unlocked capsule
2. Tap "Export as PDF" or use the menu
3. Share or save the PDF using the iOS share sheet

## Privacy

- All data is stored locally on your device
- iCloud backup is optional and uses your personal iCloud account
- No third-party analytics or tracking
- Photos are stored securely within the app's container

## App Store Information

- **Bundle ID**: com.lopodragon.timecapsule
- **Price**: $2.99 USD (one-time purchase)
- **Category**: Lifestyle
- **Platform**: iOS 17.0+

## License

MIT License - See LICENSE file for details

## Support

For issues, feature requests, or questions, please contact support or open an issue in the project repository.

## Version History

See CHANGELOG.md for version history and release notes.

---

Made with care for preserving your thoughts and memories for the future.
