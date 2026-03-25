import SwiftUI

struct CapsuleGalleryView: View {
    @EnvironmentObject var viewModel: TimeCapsuleViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if !viewModel.lockedCapsules.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Locked Capsules")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        ForEach(viewModel.lockedCapsules) { capsule in
                            CapsuleCard(capsule: capsule, isLocked: true)
                                .onTapGesture {
                                    if capsule.canUnlock {
                                        viewModel.selectedCapsule = capsule
                                    }
                                }
                        }
                    }
                }

                if !viewModel.unlockedCapsules.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Unlocked Capsules")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        ForEach(viewModel.unlockedCapsules) { capsule in
                            CapsuleCard(capsule: capsule, isLocked: false)
                                .onTapGesture {
                                    viewModel.selectedCapsule = capsule
                                }
                        }
                    }
                }

                if viewModel.capsules.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "envelope.open.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.secondary.opacity(0.5))
                            .padding(.top, 60)

                        Text("No Time Capsules Yet")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Create your first letter to your future self")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.vertical, 40)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("My Time Capsules")
        .refreshable {
            viewModel.fetchCapsules()
        }
    }
}

struct CapsuleCard: View {
    let capsule: TimeCapsule
    let isLocked: Bool

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isLocked ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                    .frame(width: 60, height: 60)

                Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                    .font(.system(size: 28))
                    .foregroundColor(isLocked ? .blue : .green)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(capsule.title)
                    .font(.headline)
                    .lineLimit(1)

                Text(capsule.createdDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)

                if isLocked {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text("Unlocks: \(capsule.unlockDate, style: .date)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)

                    if capsule.canUnlock {
                        Text("Ready to unlock!")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    } else if capsule.daysUntilUnlock > 0 {
                        Text("\(capsule.daysUntilUnlock) days remaining")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }

            Spacer()

            if !capsule.imageData.isEmpty {
                Image(systemName: "photo.fill")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        CapsuleGalleryView()
            .environmentObject(TimeCapsuleViewModel())
    }
}
