////
////  VoiceCommand.swift
////  FlavorSaver
////
////  Created by Jacky Gao on 12/9/23.
////
//
//import Foundation
//import Speech
//
//class VoiceCommand {
//    var recognizer : SFSpeechRecognizer?
//    
//    init() {
//        recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
//    }
//    
//    func requestAuthorization() async -> Bool {
//        var result : Bool = false
//        do{
//            
//            SFSpeechRecognizer.requestAuthorization(
//                {status in
//                switch status{
//                case .authorized:
//                    print("Authorized")
//                case .denied:
//                    print("Denied")
//                case .notDetermined:
//                    print("Not Determined")
//                case .restricted:
//                    print("Restricted")
//                @unknown default:
//                    print("Unknown")
//                }
//            }})
//            result = true
//        }catch{
//            print("Error with requesting authorization: \(error)")
//        }
//        return result
//    }
//    
//    func startRecording() async -> String {
//        var result : String = ""
//        do{
//            let request = SFSpeechAudioBufferRecognitionRequest()
//            let audioEngine = AVAudioEngine()
//            let inputNode = audioEngine.inputNode
//            
//            guard let recognizer = recognizer else {
//                print("Error with recognizer")
//                return result
//            }
//            
//            if !recognizer.isAvailable {
//                print("Recognizer is not available")
//                return result
//            }
//            
//            let recordingFormat = inputNode.outputFormat(forBus: 0)
//            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
//                request.append(buffer)
//            }
//            
//            audioEngine.prepare()
//            try audioEngine.start()
//            
//            let recognition = try await recognizer.recognitionTask(with: request)
//            result = recognition.bestTranscription.formattedString
//            audioEngine.stop()
//            inputNode.removeTap(onBus: 0)
//        }catch{
//            print("Error with starting recording: \(error)")
//        }
//        return result
//    }
//}
