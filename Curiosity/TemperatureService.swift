//
//  TemperatureService.swift
//  Curiosity
//
//  Created by Dee on 7/11/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class TemperatureService: NSObject {
    static let tempService = TemperatureService()
    
    let myDefaults = UserDefaults.standard
    var minTemp: Int?
    var maxTemp: Int?

    // return saved settings
    func getData() -> [String:Int]? {
        let data = myDefaults.object(forKey: "saves") as? [String:Int]
        return data
    }
    
    // save game data to NSUserdefalts
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