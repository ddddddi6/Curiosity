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
            print(result)
            if (result != nil) {
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
        if (text.contains("forward")) {
            let steps = self.parseSteps(text: text, control: "forward")
            self.carService.moveWithSteps(action: "move forward", steps: steps)
        } else if (text.contains("backward")) {
            let steps = self.parseSteps(text: text, control: "backward")
            self.carService.moveWithSteps(action: "move backward", steps: steps)
        }
    }
    
    func parseSteps(text: String, control: String) -> Int {
        var steps = 10
        if (text.contains("steps")) {
            let count = self.parseCount(result: text, after: "control", before: "steps")
            if (count != nil) {
                steps = count!
            }
        }
        return steps
    }
    
    func parseCount(result: String, after: String, before: String) -> Int? {
        let count = result.replacingOccurrences(of: after + " ", with: "").replacingOccurrences(of: " " + before, with: "")
        return Int(count)
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
}
