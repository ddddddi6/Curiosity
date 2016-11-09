//
//  SpeakControlExtension.swift
//  Curiosity
//
//  Created by HaoBoji on 25/10/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import AVFoundation

// Functions for speaking control of car
extension MainController {
    
    // start recording user's voice and parse it
    func startRecordingTask() {
        speechService.startRecording() { result in
            if (result != nil) {
                // display what user has said on screen
                self.setMessage(text: "\"" + result! + "\"")
                // parse voice input
                self.parseSpeech(result: result!)
            }
        }
    }
    
    // stop recording voice
    func stopRecordingTask() {
        speechService.audioEngine.stop()
        speechService.recognitionRequest?.endAudio()
    }
    
    // parse voice to text
    func parseSpeech(result: String) {
        let text = result.lowercased()
        // parse number in text
        let number = parseNumberInString(text: text)
        // parse command that car can understand
        let command = parseCommandInSpeech(text: text)
        if (command == nil) {
            // if cannot recognize any voice input, prompt user
            speechService.speakError()
            return
        }
        if (command!.contains("move")) {
            // move car forward or backward
            self.carService.moveWithSteps(action: command!, steps: number ?? 10)
        } else if (command!.contains("rotate")) {
            // rotate car to a certain degree, default is 90
            let degree = Double(number ?? 90)
            let steps = Int(degree / 360.0 * 33.0)
            self.carService.moveWithSteps(action: command!, steps: steps)
        }
    }
    
    // parse numbers in a string, return nil if no number in it
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
    
    // parse command in string, return nil if no known command found
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
