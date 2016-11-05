//
//  CameraViewController.swift
//  Curiosity
//
//  Created by HaoBoji on 24/10/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import CoreMotion

class MainController: UIViewController {
    
    @IBOutlet var leftUp: UIButton!
    @IBOutlet var leftDown: UIButton!
    @IBOutlet var rightUp: UIButton!
    @IBOutlet var rightDown: UIButton!
    
    @IBOutlet var message: UILabel!
    
    @IBAction func speekButtonTouchDown(_ sender: UIButton) {
        startRecordingTask()
    }
    
    @IBAction func speekButtonTouchUp(_ sender: UIButton) {
        stopRecordingTask()
    }
    
    @IBAction func stopCar(_ sender: UIButton) {
        carService.stop()
    }
    
    @IBAction func settings(_ sender: Any) {
        let controller = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController()
        controller?.modalTransitionStyle = .coverVertical
        controller?.modalPresentationStyle = .fullScreen
        present(controller!, animated: true, completion: nil)
    }
    
    // network service
    let carService = GoPiGoService()
    let speechService = SpeechService()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        monitorControlButtons()
        motionManager.startDeviceMotionUpdates()
    }
}
