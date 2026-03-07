//
//  VoiceRowCounterView.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/4/26.
//

import Foundation
import SwiftUI

struct VoiceRowCounterView: View {
    @State private var recognizer = SpeechRecognizer()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Voice Row Counter")
                .font(.title.bold())

            Text("Say “next” to increment.")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                Text("Next count: \(recognizer.nextCount)")
                    .font(.headline)

                Text("Transcript:")
                    .font(.subheadline.weight(.semibold))

                ScrollView {
                    Text(recognizer.transcribedText.isEmpty ? "…" : recognizer.transcribedText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .frame(minHeight: 120)
            }

            Spacer()

            Button {
                if recognizer.isRecording {
                    recognizer.stopRecording()
                } else {
                    recognizer.startRecording()
                }
            } label: {
                Text(recognizer.isRecording ? "Stop" : "Start Listening")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Voice Tool")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            recognizer.requestPermissions()
        }
    }
}
