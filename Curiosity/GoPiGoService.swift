//
//  GoPiGoService.swift
//  Curiosity
//
//  Created by HaoBoji on 24/10/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import Alamofire
import Starscream

// Service for raspberry pi mounted on the car
class GoPiGoService: NSObject {
    
    // Car server
    let ip = "49.127.109.179"
    // Video server
    let videoURL: String
    // Car control url
    let url: String
    // Track current http car control request
    var request: DataRequest?
    
    override init() {
        url = "http://" + ip + ":8000/"
        videoURL = "http://" + ip + ":8080/?action=stream"
        let socket = WebSocket(url: NSURL(string: "ws://" + ip + ":98/robot_control/041/t9162mkt/websocket")! as URL)
        socket.connect()
        super.init()
    }
    
    // Stop car
    func stop() {
        request = Alamofire.request(url + "stop").response(completionHandler: { (_) in
            self.request = nil
        })
    }
    
    // Continuouse moving command
    func moveContinuous(action: String, leftSpeed: Int, rightSpeed: Int) {
        if (request == nil) {
            let prameters = ["action": action, "leftSpeed": leftSpeed, "rightSpeed": rightSpeed] as [String : Any]
            request = Alamofire.request(url + "moveContinuous", parameters: prameters).response(completionHandler: { (_) in
                self.request = nil
            })
        }
    }
    
    // Move car with certain steps
    func moveWithSteps(action: String, steps: Int) {
        if (request == nil) {
            let prameters = ["action": action, "steps": steps] as [String : Any]
            request = Alamofire.request(url + "moveWithSteps", parameters: prameters).response(completionHandler: { (_) in
                self.request = nil
            })
        }
    }
}
