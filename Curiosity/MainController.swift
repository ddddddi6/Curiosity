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
    
    // Speak button did touch down
    @IBAction func speekButtonTouchDown(_ sender: UIButton) {
        startRecordingTask()
    }
    
    //  Speak button did touch up
    @IBAction func speekButtonTouchUp(_ sender: UIButton) {
        stopRecordingTask()
    }
    
    // Stop car
    @IBAction func stopCar(_ sender: UIButton) {
        carService.stop()
    }
    
    // Temperature button did click
    @IBAction func temperature(_ sender: UIButton) {
        let controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController()
        controller?.modalTransitionStyle = .coverVertical
        controller?.modalPresentationStyle = .formSheet
        present(controller!, animated: true, completion: nil)
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
        let request = URLRequest(url: URL(string: carService.videoURL)!)
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
