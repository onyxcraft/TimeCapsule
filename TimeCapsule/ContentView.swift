import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: TimeCapsuleViewModel
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                CapsuleGalleryView()
                    .tabItem {
                        Label("Gallery", systemImage: "envelope.fill")
                    }
                    .tag(0)

                VStack {
                    Text("Welcome to TimeCapsule")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    Text("Write letters to your future self")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 40)

                    Button(action: {
                        viewModel.showingCreateView = true
                    }) {
                        HStack {
                            Image(systemName: "envelope.badge.fill")
                            Text("Create Time Capsule")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .tabItem {
                    Label("Create", systemImage: "plus.circle.fill")
                }
                .tag(1)
            }
            .sheet(isPresented: $viewModel.showingCreateView) {
                CreateCapsuleView()
            }
            .sheet(item: $viewModel.selectedCapsule) { capsule in
                CapsuleDetailView(capsule: capsule)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TimeCapsuleViewModel())
}
