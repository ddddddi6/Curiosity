//
//  SpeakControlExtension.swift
//  Curiosity
//
//  Created by HaoBoji on 25/10/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

extension MainController {

    func startRecordingTask() {
        if speechService.audioEngine.isRunning {
            speechService.audioEngine.stop()
            speechService.recognitionRequest?.endAudio()
        }
        speechService.startRecording() { result in
            if (result != nil) {
                self.setMessage(text: "\"" + result! + "\"")
                self.parseSpeech(result: result!)
            }
        }
    }
    
    func stopRecordingTask() {
        if speechService.audioEngine.isRunning {
            speechService.audioEngine.stop()
            speechService.recognitionRequest?.endAudio()
        }
    }
    
    func parseSpeech(result: String) {
        let text = result.lowercased()
        let number = parseNumberInString(text: text)
        let command = parseCommandInSpeech(text: text)
        if (command == nil) {
            let errors = ["Make sure you speak English.", "I cannot understand.", "What?"]
            let toSay = errors[Int(arc4random_uniform(3))]
            let speechUtterance = AVSpeechUtterance(string: "Make sure you speak English.")
            speechSynthesizer.stopSpeaking(at: .immediate)
            speechSynthesizer.speak(speechUtterance)
            
            return
        }
        if (command!.contains("move")) {
            self.carService.moveWithSteps(action: command!, steps: number ?? 10)
        } else if (command!.contains("rotate")) {
            let degree = Double(number ?? 90)
            let steps = Int(degree / 360.0 * 33.0)
            self.carService.moveWithSteps(action: command!, steps: steps)
        }
    }
    
    func parseNumberInString(text: String) -> Int? {
        let strArr = text.components(separatedBy: " ")
        for item in strArr {
            let components = item.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            let part = components.joined()
            if let intVal = Int(part) {
                return intVal
            }
        }
        return nil
    }
    
    func parseCommandInSpeech(text: String) -> String? {
        if (text.contains("forward")) {
            return "move forward"
        } else if (text.contains("back")) {
            return "move backward"
        } else if (text.contains("left")) {
            return "rotate right"
        } else if (text.contains("right")) {
            return "rotate left"
        } else {
            return nil
        }
    }
}
