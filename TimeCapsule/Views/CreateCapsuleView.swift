import SwiftUI
import PhotosUI

struct CreateCapsuleView: View {
    @EnvironmentObject var viewModel: TimeCapsuleViewModel
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var message = ""
    @State private var unlockDate = Date().addingTimeInterval(2592000)
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var showingSealAnimation = false

    let minDate = Date().addingTimeInterval(2592000)
    let maxDate = Date().addingTimeInterval(315360000)

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text("Letter Details")) {
                        TextField("Title", text: $title)
                            .font(.headline)

                        TextEditor(text: $message)
                            .frame(minHeight: 150)
                            .overlay(alignment: .topLeading) {
                                if message.isEmpty {
                                    Text("Write your letter to your future self...")
                                        .foregroundColor(.secondary)
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                        .allowsHitTesting(false)
                                }
                            }
                    }

                    Section(header: Text("Photos")) {
                        if !selectedImages.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<selectedImages.count, id: \.self) { index in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: selectedImages[index])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))

                                            Button(action: {
                                                selectedImages.remove(at: index)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.white)
                                                    .background(Circle().fill(Color.black.opacity(0.6)))
                                            }
                                            .offset(x: 8, y: -8)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }

                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Label("Add Photos", systemImage: "photo.on.rectangle.angled")
                        }
                    }

                    Section(header: Text("Unlock Date")) {
                        DatePicker(
                            "Open on",
                            selection: $unlockDate,
                            in: minDate...maxDate,
                            displayedComponents: .date
                        )

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quick Select")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    QuickDateButton(title: "1 Month", months: 1, unlockDate: $unlockDate)
                                    QuickDateButton(title: "6 Months", months: 6, unlockDate: $unlockDate)
                                    QuickDateButton(title: "1 Year", years: 1, unlockDate: $unlockDate)
                                    QuickDateButton(title: "5 Years", years: 5, unlockDate: $unlockDate)
                                    QuickDateButton(title: "10 Years", years: 10, unlockDate: $unlockDate)
                                }
                            }
                        }
                    }

                    Section {
                        Button(action: createCapsule) {
                            HStack {
                                Spacer()
                                Text("Seal Time Capsule")
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                        .disabled(title.isEmpty || message.isEmpty)
                    }
                }

                if showingSealAnimation {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    EnvelopeAnimationView(isPresented: $showingSealAnimation) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("New Time Capsule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(images: $selectedImages, selectionLimit: 10)
            }
        }
    }

    private func createCapsule() {
        viewModel.createCapsule(
            title: title,
            message: message,
            unlockDate: unlockDate,
            images: selectedImages
        )
        showingSealAnimation = true
    }
}

struct QuickDateButton: View {
    let title: String
    var months: Int = 0
    var years: Int = 0
    @Binding var unlockDate: Date

    var body: some View {
        Button(action: {
            var components = DateComponents()
            components.month = months
            components.year = years
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                unlockDate = newDate
            }
        }) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.accentColor.opacity(0.2))
                .foregroundColor(.accentColor)
                .cornerRadius(8)
        }
    }
}

#Preview {
    CreateCapsuleView()
        .environmentObject(TimeCapsuleViewModel())
}
