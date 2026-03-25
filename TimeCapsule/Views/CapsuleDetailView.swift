import SwiftUI
import PDFKit

struct CapsuleDetailView: View {
    @EnvironmentObject var viewModel: TimeCapsuleViewModel
    @Environment(\.dismiss) var dismiss

    let capsule: TimeCapsule

    @State private var showingUnlockAnimation = false
    @State private var showingRelockSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingShareSheet = false
    @State private var pdfURL: URL?
    @State private var relockDate = Date().addingTimeInterval(2592000)

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if capsule.isLocked && !capsule.canUnlock {
                            LockedView(capsule: capsule)
                        } else {
                            if capsule.isLocked && capsule.canUnlock {
                                UnlockPromptView(onUnlock: {
                                    showingUnlockAnimation = true
                                })
                            } else {
                                UnlockedContentView(
                                    capsule: capsule,
                                    onRelock: {
                                        showingRelockSheet = true
                                    },
                                    onExportPDF: {
                                        exportToPDF()
                                    }
                                )
                            }
                        }
                    }
                    .padding()
                }

                if showingUnlockAnimation {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()

                    UnlockAnimationView(isPresented: $showingUnlockAnimation) {
                        viewModel.unlockCapsule(capsule)
                    }
                }
            }
            .navigationTitle(capsule.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        if !capsule.isLocked {
                            Button(action: {
                                exportToPDF()
                            }) {
                                Label("Export as PDF", systemImage: "square.and.arrow.up")
                            }

                            Button(action: {
                                showingRelockSheet = true
                            }) {
                                Label("Re-lock Capsule", systemImage: "lock.fill")
                            }
                        }

                        Button(role: .destructive, action: {
                            showingDeleteAlert = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingRelockSheet) {
                RelockSheet(
                    capsule: capsule,
                    relockDate: $relockDate,
                    onRelock: {
                        viewModel.relockCapsule(capsule, until: relockDate)
                        showingRelockSheet = false
                        dismiss()
                    }
                )
            }
            .alert("Delete Time Capsule?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.deleteCapsule(capsule)
                    dismiss()
                }
            } message: {
                Text("This action cannot be undone.")
            }
            .sheet(isPresented: $showingShareSheet) {
                if let pdfURL = pdfURL {
                    ShareSheet(items: [pdfURL])
                }
            }
        }
    }

    private func exportToPDF() {
        let images = capsule.imageData.compactMap { UIImage(data: $0) }
        pdfURL = PDFGenerator.generatePDF(
            title: capsule.title,
            message: capsule.message,
            createdDate: capsule.createdDate,
            unlockDate: capsule.unlockDate,
            images: images
        )
        if pdfURL != nil {
            showingShareSheet = true
        }
    }
}

struct LockedView: View {
    let capsule: TimeCapsule

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)
                .padding(.top, 40)

            VStack(spacing: 8) {
                Text("This capsule is locked")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Unlocks on \(capsule.unlockDate, style: .date)")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 12) {
                if capsule.yearsUntilUnlock > 0 {
                    TimeRemainingRow(
                        icon: "calendar",
                        value: "\(capsule.yearsUntilUnlock)",
                        label: capsule.yearsUntilUnlock == 1 ? "year" : "years"
                    )
                }

                TimeRemainingRow(
                    icon: "clock",
                    value: "\(capsule.daysUntilUnlock)",
                    label: capsule.daysUntilUnlock == 1 ? "day" : "days"
                )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(uiColor: .secondarySystemBackground))
            )

            Text("Your letter is waiting for you in the future")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
    }
}

struct UnlockPromptView: View {
    let onUnlock: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "envelope.badge.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)
                .padding(.top, 40)

            VStack(spacing: 12) {
                Text("Time to Open!")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Your time capsule is ready to be unlocked")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: onUnlock) {
                HStack {
                    Image(systemName: "lock.open.fill")
                    Text("Unlock Now")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(15)
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}

struct UnlockedContentView: View {
    let capsule: TimeCapsule
    let onRelock: () -> Void
    let onExportPDF: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(capsule.createdDate, style: .date)
                        .font(.subheadline)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Unlocked")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(capsule.unlockDate, style: .date)
                        .font(.subheadline)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .secondarySystemBackground))
            )

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Text("Your Letter")
                    .font(.headline)

                Text(capsule.message)
                    .font(.body)
                    .lineSpacing(8)
            }

            if !capsule.imageData.isEmpty {
                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Photos")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<capsule.imageData.count, id: \.self) { index in
                                if let image = UIImage(data: capsule.imageData[index]) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                }
            }

            Divider()

            VStack(spacing: 12) {
                Button(action: onExportPDF) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export as PDF")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                }

                Button(action: onRelock) {
                    HStack {
                        Image(systemName: "lock.rotation")
                        Text("Re-lock This Capsule")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct TimeRemainingRow: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(label)
                .font(.headline)
                .foregroundColor(.secondary)

            Spacer()
        }
    }
}

struct RelockSheet: View {
    let capsule: TimeCapsule
    @Binding var relockDate: Date
    let onRelock: () -> Void

    @Environment(\.dismiss) var dismiss

    let minDate = Date().addingTimeInterval(2592000)
    let maxDate = Date().addingTimeInterval(315360000)

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Unlock Date")) {
                    DatePicker(
                        "Unlock on",
                        selection: $relockDate,
                        in: minDate...maxDate,
                        displayedComponents: .date
                    )

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            QuickDateButton(title: "1 Month", months: 1, unlockDate: $relockDate)
                            QuickDateButton(title: "6 Months", months: 6, unlockDate: $relockDate)
                            QuickDateButton(title: "1 Year", years: 1, unlockDate: $relockDate)
                            QuickDateButton(title: "5 Years", years: 5, unlockDate: $relockDate)
                        }
                    }
                }

                Section {
                    Button(action: onRelock) {
                        HStack {
                            Spacer()
                            Text("Re-lock Capsule")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Re-lock Time Capsule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    CapsuleDetailView(
        capsule: TimeCapsule(
            title: "Letter to Future Me",
            message: "Remember to stay positive and keep learning!",
            unlockDate: Date().addingTimeInterval(86400 * 30)
        )
    )
    .environmentObject(TimeCapsuleViewModel())
}
