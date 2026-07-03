//
//  OnboardingScreen.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 12/01/1448 AH.
//

import SwiftUI

struct OnboardingScreen: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    var body: some View {
        
        VStack {
            HStack{
                HStack (spacing : 0 ) {
                    Text("\(currentPage+1)")
                        .font(Font.body.bold())
                    Text("/\(OnboardingPage.allCases.count)")
                        .font(Font.body.bold())
                        .opacity(0.3)
                }
                Spacer()
                Button("Skip") {
                    UserDefaults.standard.set(true, forKey: AppConstants.hasSeenOnboarding)
                    print("Home Screen will appear")
                }
                .font(Font.body.bold())
                .foregroundStyle(Color.primary)
            }
            
            TabView(selection: $currentPage) {
                ForEach(OnboardingPage.allCases, id: \.rawValue) { page in
                    getPageView(for: page)
                        .tag(page.rawValue)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(), value: currentPage)
            .onAppear { isAnimating = true }
            
            HStack {
                if currentPage > 0 {
                    Text("Prev")
                        .font(Font.body.bold())
                        .opacity(0.3)
                        .onTapGesture {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                }
                
                Spacer()
                ForEach(0 ..< OnboardingPage.allCases.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10).fill()
                        .frame(width: currentPage == index ? 40 : 8, height: 8)
                        .opacity(index == currentPage ? 1 : 0.3)
                        .animation(.spring(), value: currentPage)
                }
                Spacer()
                
                Text(currentPage < OnboardingPage.allCases.count - 1 ? "Next" : "Start")
                    .font(Font.body.bold())
                    .foregroundStyle(Color.appPrimary)
                    .onTapGesture {
                        withAnimation {
                            if currentPage < OnboardingPage.allCases.count - 1 {
                                currentPage += 1
                            } else {
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                                print("Home Screen will appear")
                            }
                        }
                    }
                
            }
        }
        .safeAreaPadding()
    }
    
    private func getPageView(for page: OnboardingPage) -> some View {
        let isActive = (currentPage == page.rawValue)
        
        return VStack(spacing: 20) {
            Image(page.image)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .scaleEffect(isActive ? 1.0 : 0.6)
                .opacity(isActive ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.5), value: isActive)
            
            Text(page.title)
                .font(Font.largeTitle.bold())
            
            Text(page.description)
                .font(.system(.title3, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .opacity(isActive ? 1 : 0)
                .offset(y: isActive ? 0: 20)
                .animation(.spring(dampingFraction: 0.8).delay(0.2), value: isActive)
        }
    }
}


#Preview {
    OnboardingScreen()
}
