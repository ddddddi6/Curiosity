//
//  GoPiGoService.swift
//  Curiosity
//
//  Created by HaoBoji on 24/10/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import Alamofire


class GoPiGoService: NSObject {
    
    // Car server
    let url = "http://172.24.1.1:8000/"
    var request: DataRequest?
    
    // Video server
    let videoURL = "http://172.24.1.1:98/"
    
    // Stop car
    func stop() {
        request = Alamofire.request(url + "stop").response(completionHandler: { (_) in
            self.request = nil
        })
    }
    
    func moveContinuous(action: String, leftSpeed: Int, rightSpeed: Int) {
        if (request == nil) {
            let prameters = ["action": action, "leftSpeed": leftSpeed, "rightSpeed": rightSpeed] as [String : Any]
            request = Alamofire.request(url + "moveContinuous", parameters: prameters).response(completionHandler: { (_) in
                self.request = nil
            })
        }
    }
    
    func moveWithSteps(action: String, steps: Int) {
        if (request == nil) {
            let prameters = ["action": action, "steps": steps] as [String : Any]
            request = Alamofire.request(url + "moveWithSteps", parameters: prameters).response(completionHandler: { (_) in
                self.request = nil
            })
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func keepRunning() {
        DispatchQueue.global(qos: .userInitiated).async {
            while (true) {
                _ = Alamofire.request(self.videoURL).response(completionHandler: { (_) in })
                sleep(10)
            }
        }
    }
    
    
    
//    func stop() {
//        taskId = (taskId + 1)%1024
//    }
    
//    
//    func recursiveMove(count: Int) {
//        stop()
//        DispatchQueue.global(qos: .userInteractive).async {
//            let currentTask = self.taskId
//            while (currentTask == self.taskId) {
//                self.move(action: "w")
//                usleep(100000)
//                print(1)
//            }
//        }
//    }
}
