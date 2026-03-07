//
//  WithSplashView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import SwiftUI

struct WithSplashView: View {
    // WithSplashView: identical to old KnitPickApp but w/splash screen capabilities upon launch
    @State private var showSplash = true
    var body: some View {
        ZStack {
            ContentView()
                .environment(\.font, Font.custom("Pixelstitch", size: 16))

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
