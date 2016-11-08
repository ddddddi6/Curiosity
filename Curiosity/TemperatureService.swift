//
//  TemperatureService.swift
//  Curiosity
//
//  Created by Dee on 7/11/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

class TemperatureService: NSObject {
    static let tempService = TemperatureService()
    
    // Userdefaults
    let myDefaults = UserDefaults.standard
    var minTemp: Int?
    var maxTemp: Int?
    
    // Temperature server
    let url = "http://118.138.161.114:3000/"
    var request: DataRequest?
    
    // set device token
    func setToken() {
        let token = FIRInstanceID.instanceID().token()
        print(token)
        
        request = Alamofire.request(url + "token?token=" + token!).response(completionHandler: { (_) in
            self.request = nil
        })
    }
    
    // Set temperature range
    func setRange(minTemp: Int, maxTemp: Int) {
        request = Alamofire.request(url + "personalTemperature?ltemp=" + String(minTemp) + "&htemp=" + String(maxTemp)).response(completionHandler: { (_) in
            self.request = nil
        })
    }

    // return saved settings
    func getData() -> [String:Int]? {
        let data = myDefaults.object(forKey: "saves") as? [String:Int]
        return data
    }
    
    // save defined temperature range data to NSUserdefalts
    func saveData(minTempSetting: Int, maxTempSetting: Int) {
        if (myDefaults.object(forKey: "saves") == nil) {
            // the savedMovie `NSUserDefaults` does not exist
            let array = ["min": minTempSetting, "max": maxTempSetting]
            
            // then update whats in the `NSUserDefault`
            myDefaults.set(array, forKey: "saves")
            
            // call this after update
            myDefaults.synchronize()
            
        } else {
            // update data in NSUserdefault
            var array = getData()
            array?.updateValue(minTempSetting, forKey: "min")
            array?.updateValue(maxTempSetting, forKey: "max")
            
            myDefaults.setValue(array, forKey: "saves")
        }
    }
}
