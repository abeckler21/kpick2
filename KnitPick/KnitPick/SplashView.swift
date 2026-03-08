//
//  SplashView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/7/26.
//

import SwiftUI

// SplashView.swift: define the splash screen to be shown on launch

struct SplashView: View {
    // SplashView: define the splash screen
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            // set splash screen background to black
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // text for splash screen
                Spacer()
                VStack(spacing: 10) {
                    Text("KnitPick")
                        .font(.system(size: 40, weight: .bold))

                    Text("by Eve Tanios & Abby Beckler")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.8))
                }

                Text("save projects • explore tools • browse patterns")
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Spacer()

                Text("tap to continue")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.55))
                    .padding(.bottom, 30)
            }
            .padding()
        }
        .contentShape(Rectangle())
        // make disappear on tap or after 2 seconds
        .onTapGesture {
            onFinish()
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            onFinish()
        }
    }
}
