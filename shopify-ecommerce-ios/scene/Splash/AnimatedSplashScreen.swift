import SwiftUI

struct AnimatedSplashScreen<Content: View>: View {
    let content: Content
    
    // Animation states
    @State private var isPulsing = false
    @State private var isFadingOut = false
    @State private var isSplashFinished = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
            
            if !isSplashFinished {
                ZStack {
                    Color("appBlue")
                        .ignoresSafeArea()
                    
                    Image("splashLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .scaleEffect(isPulsing ? 1.05 : 1.0)
                        .brightness(isPulsing ? 0.08 : 0.0)
                        .shadow(color: .white.opacity(isPulsing ? 0.2 : 0.0), radius: isPulsing ? 8 : 0)
                }
                .opacity(isFadingOut ? 0.0 : 1.0)
                .zIndex(1)
                .onAppear {
                    let pulseDuration: Double = 0.7
                    let repeats = 4
                    let totalPulseTime = pulseDuration * Double(repeats)
                    
                    withAnimation(.easeInOut(duration: pulseDuration).repeatCount(repeats, autoreverses: true)) {
                        isPulsing = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + totalPulseTime) {
                        isPulsing = false
                        
                        withAnimation(.easeOut(duration: 1.5)) {
                            isFadingOut = true
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + totalPulseTime + 1.5) {
                        isSplashFinished = true
                    }
                }
            }
        }
    }
}
