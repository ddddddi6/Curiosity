//
//  SpeechService.swift
//  Curiosity
//
//  Created by HaoBoji on 26/10/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import Speech

// Speech Recognizer and Synthesizer
class SpeechService: NSObject, SFSpeechRecognizerDelegate {
    
    // vars for speech recognition
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-UK"))
    let audioEngine = AVAudioEngine()
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    // to speek errors
    let speechSynthesizer = AVSpeechSynthesizer()
    
    // Initialization, ask for permission
    override init() {
        super.init()
        speechRecognizer!.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                break
            case .denied:
                print("User denied access to speech recognition")
                break
            case .restricted:
                print("Speech recognition restricted on this device")
                break
            case .notDetermined:
                print("Speech recognition not yet authorized")
                break
            }
            OperationQueue.main.addOperation() {
            }
        }
    }
    
    // Start recording audio and recognition
    func startRecording(completion: @escaping (_ result: String?) -> Void) {
        // stop pervious task
        stopRecording()
        // record audio
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        // send recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = false
        // handle recognition result
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if result != nil {
                completion(result?.bestTranscription.formattedString)
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    // stop audio recording
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
        }
    }
    
    // feedback to user if cannot recognize what user said
    func speakError() {
        stopRecording()
        let errors = ["Make sure you speak English.", "Sorry, I didn't recognize that.", "What?"]
        let toSay = errors[Int(arc4random_uniform(3))]
        let speechUtterance = AVSpeechUtterance(string: toSay)
        speechSynthesizer.speak(speechUtterance)
    }
}
