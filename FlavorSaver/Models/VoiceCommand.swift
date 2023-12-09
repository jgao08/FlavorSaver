//
//  VoiceCommand.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 12/9/23.
//
// Guidance for class taken from https://medium.com/ios-os-x-development/speech-recognition-with-swift-in-ios-10-50d5f4e59c48

import Foundation
import Speech

class VoiceControl: ObservableObject {
    @Published var result : Direction = .none
    
    let audioEngine = AVAudioEngine()
    let request = SFSpeechAudioBufferRecognitionRequest()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    init() {
        startSpeechRecognition()
    }
    
    func startSpeechRecognition() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                print("Authorized")
            }else{
                print("Not authorized")
            }
        }
    }
    
    func startSpeech() {
        print("fired")
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            speechRecognizer.recognitionTask(with: request) { result, error in
                guard let result = result else {
                    print("Recognition error: \(error ?? NSError())")
                    return
                }
                
                let recognizedText = result.bestTranscription.formattedString
                if recognizedText.lowercased().contains("next") {
                    self.result = .next
                } else if recognizedText.lowercased().contains("back") {
                    self.result = .back
                }
                print(recognizedText)
            }
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    func stopSpeech(){
        audioEngine.stop()
        request.endAudio()
    }
    
    func handleVoiceCommand(text: String) {
        if text.lowercased().contains("next") {
            result = .next
        } else if text.lowercased().contains("back") {
            result = .back
        }
    }
    
}


enum Direction {
    case next
    case back
    case none
}
