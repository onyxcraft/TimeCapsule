import SwiftUI

struct UnlockAnimationView: View {
    @Binding var isPresented: Bool
    let onComplete: () -> Void

    @State private var lockScale: CGFloat = 1.0
    @State private var lockRotation: Double = 0
    @State private var lockOpacity: Double = 1.0
    @State private var particlesOpacity: Double = 0
    @State private var showUnlocked: Bool = false
    @State private var unlockedScale: CGFloat = 0.5

    var body: some View {
        ZStack {
            if !showUnlocked {
                ZStack {
                    ForEach(0..<12) { index in
                        Circle()
                            .fill(Color.yellow.opacity(0.7))
                            .frame(width: 8, height: 8)
                            .offset(y: -80)
                            .rotationEffect(.degrees(Double(index) * 30))
                            .opacity(particlesOpacity)
                    }

                    Image(systemName: "lock.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                        .scaleEffect(lockScale)
                        .rotationEffect(.degrees(lockRotation))
                        .opacity(lockOpacity)
                }
            }

            if showUnlocked {
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 120, height: 120)

                        Image(systemName: "envelope.open.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                    }
                    .scaleEffect(unlockedScale)

                    Text("Unlocked!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(unlockedScale > 0.9 ? 1 : 0)
                }
            }
        }
        .onAppear {
            performAnimation()
        }
    }

    private func performAnimation() {
        withAnimation(.easeInOut(duration: 0.3).repeatCount(3, autoreverses: true)) {
            lockScale = 1.15
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.linear(duration: 0.4)) {
                lockRotation = 20
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(.linear(duration: 0.4)) {
                lockRotation = -20
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                lockScale = 0.1
                lockOpacity = 0
                particlesOpacity = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showUnlocked = true

            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                unlockedScale = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                unlockedScale = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPresented = false
                onComplete()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.8)
            .ignoresSafeArea()

        UnlockAnimationView(isPresented: .constant(true)) {
            print("Unlock complete")
        }
    }
}
