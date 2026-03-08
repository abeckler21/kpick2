//
//  WithSplashView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import SwiftUI

// WithSplashView.swift: define app w/splash view shown on launch

struct WithSplashView: View {
    // WithSplashView: identical to old KnitPickApp but w/splash screen capabilities upon launch
    @State private var showSplash = true
    @State private var showRateAlert = false

    var body: some View {
        ZStack {
            ContentView()
                .environment(\.font, Font.custom("Pixelstitch", size: 16))
            
                // if third launch, show rating alert
                .onAppear {
                    let count = UserDefaults.standard.integer(forKey: "launch_count")
                    if (count == 3) {
                        print("hello")
                        showRateAlert = true
                    }
                }
                .alert("Rate this App", isPresented: $showRateAlert) {
                    Button("Rate Now", role: .cancel) {}
                    Button("Maybe Later", role: .cancel) {}
                } message: {
                    Text("If you enjoy Knit Pick, please consider rating it in the App Store!")
                }

            if showSplash {
                // if we should show splash, set the splashview to show
                SplashView {
                    withAnimation(.easeOut(duration: 0.35)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
}
