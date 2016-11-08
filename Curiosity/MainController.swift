//
//  CameraViewController.swift
//  Curiosity
//
//  Created by HaoBoji on 24/10/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

// Main controller
class MainController: UIViewController {
    
    @IBOutlet var leftUp: UIButton!
    @IBOutlet var leftDown: UIButton!
    @IBOutlet var rightUp: UIButton!
    @IBOutlet var rightDown: UIButton!
    
    @IBOutlet var message: UILabel!
    @IBOutlet var liveVideo: UIWebView!
    @IBOutlet var temperatureButton: UIButton!
    
    
    @IBAction func speekButtonTouchDown(_ sender: UIButton) {
        startRecordingTask()
    }
    
    @IBAction func speekButtonTouchUp(_ sender: UIButton) {
        stopRecordingTask()
    }
    
    @IBAction func stopCar(_ sender: UIButton) {
        carService.stop()
    }
    
    @IBAction func temperature(_ sender: UIButton) {
        let controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController()
        controller?.modalTransitionStyle = .coverVertical
        controller?.modalPresentationStyle = .formSheet
        present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func settings(_ sender: Any) {
        let controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController()
        controller?.modalTransitionStyle = .coverVertical
        controller?.modalPresentationStyle = .formSheet
        present(controller!, animated: true, completion: nil)
        let request = URLRequest(url: URL(string: "http://172.24.1.1:8080/?action=stream")!)
        liveVideo.loadRequest(request)
    }
    
    // network service
    let carService = GoPiGoService()
    var speechService = SpeechService()
    // to detect gravity
    let motionManager = CMMotionManager()
    
    // Set message in the middle of the screen
    func setMessage(text: String) {
        message.text = text
        let deadline = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            if (self.message.text == text) {
                self.message.text = ""
            }
        }
    }
    
    // update temperature of temperature button
    func setTemperature(text: String) {
        temperatureButton.setTitle(text + "°C", for: .normal)
        temperatureButton.setTitle(text + "°C", for: .highlighted)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initializations
        monitorControlButtons()
        motionManager.startDeviceMotionUpdates()
        // recieve video
        self.liveVideo.frame = self.view.bounds
        self.liveVideo.scalesPageToFit = true
        let request = URLRequest(url: URL(string: "http://172.24.1.1:8080/?action=stream")!)
        liveVideo.loadRequest(request)
        // Sync temperature
        DispatchQueue.global(qos: .background).async {
            while(true) {
                sleep(1)
                TemperatureService.tempService.getTemperature(completion: { (result) in
                    self.setTemperature(text: result)
                })
            }
        }
    }
}
