//
//  SettingsController.swift
//  Curiosity
//
//  Created by Dee on 5/11/16.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class SettingsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var maxField: UITextField!
    @IBOutlet var minField: UITextField!
    
    var values = Array(-40...50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = FIRInstanceID.instanceID().token()
        print(token)
        
        // popup a picker view when user start edit the textfield
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.height / 2.5))
        pickerView.backgroundColor = .white
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // define the picker view
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(SettingsController.donePicker(_:)))
        
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        minField.inputView = pickerView
        minField.inputAccessoryView = toolBar
        
        maxField.inputView = pickerView
        maxField.inputAccessoryView = toolBar


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePicker(_ sender: UIBarButtonItem) {
        if minField.isEditing {
            minField.resignFirstResponder()
        } else if maxField.isEditing {
            maxField.resignFirstResponder()
        }
    }
    
    @IBAction func doneSetting(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Pickerview settings
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let temp = String(values[row])
        return temp
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if minField.isEditing {
            let temp = String(values[row])
            minField.text = temp
        } else if maxField.isEditing {
            let temp = String(values[row])
            maxField.text = temp
        }
    }
    
//    @IBAction func setMin(_ sender: UITextField) {
//    }
//
//    @IBAction func setMax(_ sender: UITextField) {
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
