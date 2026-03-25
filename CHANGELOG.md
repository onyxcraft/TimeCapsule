# Changelog

All notable changes to TimeCapsule will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-25

### Added
- Initial release of TimeCapsule
- Create time capsules with text and photos
- Lock capsules with unlock dates from 1 month to 10 years
- Beautiful envelope sealing animation when creating capsules
- Unlock animation when opening capsules
- Push notifications when capsules are ready to unlock
- Gallery view showing locked and unlocked capsules
- View days/years remaining until unlock
- Re-lock opened capsules for another period
- Export unlocked capsules as PDF
- iCloud backup integration
- Full dark mode support
- Photo library integration (up to 10 photos per capsule)
- Swipe to delete capsules
- Quick date selection (1 month, 6 months, 1 year, 5 years, 10 years)

### Features
- **Write Letters**: Compose meaningful messages to your future self
- **Photo Attachments**: Add up to 10 photos per capsule
- **Secure Lock**: Capsules cannot be opened before unlock date
- **Notifications**: Get alerted when capsules unlock
- **Animations**: Beautiful envelope sealing and unlock animations
- **PDF Export**: Export unlocked letters as PDF documents
- **iCloud Sync**: Automatic backup to iCloud
- **Dark Mode**: Full iOS dark mode support

### Technical
- Built with SwiftUI and SwiftData
- MVVM architecture pattern
- iOS 17.0+ requirement
- No external dependencies
- Full iCloud CloudKit integration
- Local push notifications with UserNotifications framework
- PhotosUI integration for photo picker
- PDFKit for PDF generation

### Design
- Clean, modern interface
- Intuitive navigation with tab bar
- Smooth animations and transitions
- Accessible color scheme
- Support for all iPhone and iPad screen sizes

---

## Future Considerations

### [1.1.0] - Potential Future Release
- Widget support for upcoming unlocks
- Face ID/Touch ID for extra security
- Custom themes and colors
- Voice memos in capsules
- Sharing capsules with others
- Scheduled reminders before unlock
- Statistics and insights

### [1.2.0] - Potential Future Release
- Apple Watch companion app
- Multiple photo layouts in PDF
- Video attachments support
- Location tagging
- Weather data at creation time
- Handwriting support with Apple Pencil
