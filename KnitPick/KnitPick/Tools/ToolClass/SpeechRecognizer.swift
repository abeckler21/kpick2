//
//  SpeechRecognizer.swift
//  KnitPick
//
//  Created by Abigail Beckler on 3/4/26.
//

import Foundation
import SwiftUI
import Speech
import AVFoundation
import Observation

// SpeechRecognizer.swift: define the SpeechRecognizer class for next counter

@Observable
class SpeechRecognizer {
    // SpeechRecognizer: class to record, transcribe, and count occurrences of 'next'
    var isRecording = false
    var transcribedText = ""
    var nextCount = 0
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func requestPermissions() {
        // requestPermissions: request authorizations on app launch
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized.")
                default:
                    print("Speech recognition not authorized.")
                }
            }
        }
    }
    
    func startRecording() {
        // startRecording: begin recording
        if recognitionTask != nil {
            // clear prev state
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // setup Audio Session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord,mode: .default,options: [.mixWithOthers, .defaultToSpeaker])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create request") }
        recognitionRequest.shouldReportPartialResults = true // give us live updates
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            DispatchQueue.main.async {
                self.isRecording = true
                self.transcribedText = ""
                self.nextCount = 0
            }
        } catch {
            print("Audio Engine failed to start: \(error.localizedDescription)")
            return
        }
        
        // start the recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                let text = result.bestTranscription.formattedString
                
                // update the UI on the main thread w/transcription
                DispatchQueue.main.async {
                    self.transcribedText = text
                    self.countNextWords(in: text)
                }
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        }
    }
    
    func stopRecording() {
        // stopRecording: stop the recording
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        isRecording = false
    }
    
    private func countNextWords(in text: String) {
        // countNextWords: logic to count the occurrences of the word "next"
        // lowercase the text, split it by spaces and newlines
        let words = text.lowercased().components(separatedBy: .whitespacesAndNewlines)
        
        // filter out punctuation and find exact matches for "next"
        let count = words.filter { word in
            let cleanedWord = word.trimmingCharacters(in: .punctuationCharacters)
            return cleanedWord == "next"
        }.count
        
        self.nextCount = count
    }
}
