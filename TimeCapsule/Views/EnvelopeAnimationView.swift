import SwiftUI

struct EnvelopeAnimationView: View {
    @Binding var isPresented: Bool
    let onComplete: () -> Void

    @State private var flapAngle: Double = 0
    @State private var envelopeScale: CGFloat = 0.5
    @State private var envelopeOpacity: Double = 0
    @State private var sealOpacity: Double = 0
    @State private var sealScale: CGFloat = 0.3
    @State private var showCheckmark: Bool = false

    var body: some View {
        VStack {
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 0.95, green: 0.90, blue: 0.85))
                        .frame(width: 200, height: 140)
                        .shadow(radius: 10)

                    Rectangle()
                        .fill(Color(red: 0.90, green: 0.85, blue: 0.75))
                        .frame(width: 200, height: 2)
                        .offset(y: -30)

                    EnvelopeFlap()
                        .fill(Color(red: 0.92, green: 0.87, blue: 0.80))
                        .frame(width: 200, height: 80)
                        .offset(y: -70)
                        .rotation3DEffect(
                            .degrees(flapAngle),
                            axis: (x: 1, y: 0, z: 0),
                            anchor: .bottom
                        )
                        .shadow(radius: flapAngle > 90 ? 5 : 0)
                }

                Circle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "seal.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    )
                    .scaleEffect(sealScale)
                    .opacity(sealOpacity)
                    .offset(y: -20)

                if showCheckmark {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .scaleEffect(envelopeScale)
            .opacity(envelopeOpacity)

            if showCheckmark {
                Text("Time Capsule Sealed!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            performAnimation()
        }
    }

    private func performAnimation() {
        withAnimation(.easeOut(duration: 0.4)) {
            envelopeScale = 1.0
            envelopeOpacity = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                flapAngle = 180
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                sealOpacity = 1.0
                sealScale = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showCheckmark = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                envelopeOpacity = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPresented = false
                onComplete()
            }
        }
    }
}

struct EnvelopeFlap: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.4)
            .ignoresSafeArea()

        EnvelopeAnimationView(isPresented: .constant(true)) {
            print("Animation complete")
        }
    }
}
