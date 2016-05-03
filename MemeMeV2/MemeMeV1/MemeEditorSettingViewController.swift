//
//  MemeEditorSettingViewController.swift
//  MemeMeV2
//
//  Created by Yu-Jen Chang on 4/27/16.
//  Copyright © 2016 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorSettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var imageCroppingEnabled: Bool?
    
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontPicker: UIPickerView!
    
    var fontFamilyName: [String] = [String]()
    var fontPickerData: [String] = [String]()
    var userSelectedFont: String?
    var editedMeme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontFamilyName = UIFont.familyNames()
        fontPickerData = getAllFontNames()
        
        fontPicker.delegate = self
        fontPicker.dataSource = self
    }
    
    // get all the font names
    func getAllFontNames() -> [String] {
        var fontNameArray: [String] = [String]()
        for name in fontFamilyName {
            fontNameArray.append(name)
        }
        return fontNameArray
    }
    
    // number of columns of picker view data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // number of rows of picker view data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontPickerData.count
    }
    
    // display the font name
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontPickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userSelectedFont = fontPickerData[row]
        fontLabel.font = UIFont(name: fontPickerData[row], size: 15.0)
    }
    
    // enable/disable image cropping
    @IBAction func toggleToEnableImageCropping(sender: UISwitch) {
        imageCroppingEnabled = sender.on
    }
    
    // apply the setting
    @IBAction func applySetting(sender: AnyObject) {
        let controller: MemeEditorViewController
        controller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        controller.enableCropping = imageCroppingEnabled
        controller.selectedFont = userSelectedFont
        // if user is editing the existed meme, apply the setting to existed meme
        controller.memeToBeEdited = editedMeme
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
