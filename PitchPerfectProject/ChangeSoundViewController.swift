//
//  ChangeSoundViewController.swift
//  PitchPerfectProject
//
//  Created by Anna Kulaieva on 7/25/19.
//  Copyright © 2019 Anna Kulaieva. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ChangeSoundViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    var currentEffectRow = 0
    
    @IBOutlet weak var effectsButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var effectsPicker: UIPickerView!
    
    let effectsOptions = ["Fast", "Slow", "High Pitch", "Low Pitch", "Echo", "Reverb"]
    
//    Configuring UI when it is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupAudio()
        configureUI(.notPlaying)
        effectsPicker.delegate = self
        effectsPicker.dataSource = self
        effectsPicker.isHidden = false
    }
    
/*
    MARK: - Setting up the picker view delegate functions.
*/
    
//    Setting the number fo components in the picker view row
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return (1)
    }
    
//    Changing the text color in picker view to the custom one
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let myBlueColor = UIColor(red: 34/256, green: 72/256, blue: 111/256, alpha: 1)
        return NSAttributedString(string: effectsOptions[row], attributes: [NSAttributedString.Key.foregroundColor: myBlueColor])
    }
    
//    Returning the currently picked option
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return (effectsOptions[row])
    }

//    Setting the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (effectsOptions.count)
    }
    
//    Setting the effectsButton to match currently picked sound effect
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        effectsButton.setImage(UIImage(named: effectsOptions[row]), for: effectsButton.state)
        currentEffectRow = row
    }
    
/*
     MARK: - Audio manipulations.
*/
    
//    Play sound with picked audio essect applied
    @IBAction func playRecordedSound(_ sender: UIButton) {
        switch (effectsOptions[currentEffectRow]) {
        case "Fast":
            playSound(rate: 1.5)
        case "Slow":
            playSound(rate: 0.5)
        case "High Pitch":
            playSound(pitch: 1000)
        case "Low Pitch":
            playSound(pitch: -1000)
        case "Echo":
            playSound(echo: true)
        case "Reverb":
            playSound(reverb: true)
        default:
            playSound(rate: 1.0)
        }
        configureUI(.playing)
    }
    
//    Stop audio when Stop button is pressed
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopAudio()
    }
}
