//
//  ButtonControlExtension.swift
//  Curiosity
//
//  Created by HaoBoji on 24/10/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import CoreMotion


// Functions for Car wheel control buttons
extension MainController {
    
    // monitor control button states
    func monitorControlButtons() {
        DispatchQueue.global(qos: .userInteractive).async {
            while (true) {
                usleep(10000)
                // set default speed for wheels
                var leftSpeed = 100
                var rightSpeed = 100
                // set speed for wheels based on angle of device
                if (self.motionManager.deviceMotion?.gravity.y != nil) {
                    let tilt = self.motionManager.deviceMotion!.gravity.y
                    leftSpeed = leftSpeed + Int(tilt * 50)
                    rightSpeed = rightSpeed - Int(tilt * 50)
                }
                // monitor button states
                if (self.leftUp.state == .highlighted && self.rightUp.state == .highlighted) {
                    self.carService.moveContinuous(action: "move forward", leftSpeed: leftSpeed, rightSpeed: rightSpeed)
                } else if (self.leftDown.state == .highlighted && self.rightDown.state == .highlighted) {
                    self.carService.moveContinuous(action: "move backward", leftSpeed: leftSpeed, rightSpeed: rightSpeed)
                } else if (self.leftUp.state == .highlighted && self.rightDown.state == .highlighted) {
                    self.carService.moveContinuous(action: "rotate left", leftSpeed: leftSpeed, rightSpeed: rightSpeed)
                } else if (self.leftDown.state == .highlighted && self.rightUp.state == .highlighted) {
                    self.carService.moveContinuous(action: "rotate right", leftSpeed: leftSpeed, rightSpeed: rightSpeed)
                } else if (self.leftUp.state == .highlighted) {
                    self.carService.moveContinuous(action: "turn left", leftSpeed: leftSpeed, rightSpeed: rightSpeed)
                } else if (self.rightUp.state == .highlighted) {
                    self.carService.moveContinuous(action: "turn right", leftSpeed: leftSpeed, rightSpeed: rightSpeed)
                } else if (self.leftDown.state == .highlighted) {
                    self.carService.moveContinuous(action: "move backward", leftSpeed: 0, rightSpeed: rightSpeed)
                } else if (self.rightDown.state == .highlighted) {
                    self.carService.moveContinuous(action: "move backward", leftSpeed: leftSpeed, rightSpeed: 0)
                }
            }
        }
    }
}
