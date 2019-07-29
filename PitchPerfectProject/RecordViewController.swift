//
//  RecordViewController.swift
//  PitchPerfectProject
//
//  Created by Anna Kulaieva on 7/19/19.
//  Copyright © 2019 Anna Kulaieva. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    let audioSession = AVAudioSession.sharedInstance()
    
/*
     MARK: - Change the UI state.
*/
    
//    Disable StopRecording button when the app is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordButton.isEnabled = false
        stopRecordButton.isHidden = true
    }
    
//    Update UI due to current recording state
    func updateUI(isRecording: Bool){
        if (isRecording)
        {
            stopRecordButton.isEnabled = true
            stopRecordButton.isHidden = false
            recordButton.isEnabled = false
        }
        else
        {
            recordButton.isEnabled = true
            stopRecordButton.isEnabled = false
            stopRecordButton.isHidden = true
        }
    }
    
/*
     MARK: - Record audio file to work with.
*/

//    Find the pass, where the recorded audio will be saved and create the full link to it.
//    Setting up the audio recorder.
    @IBAction func recordAudio(_ sender: UIButton) {
        updateUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let pathArray = [dirPath, "audio.wav"]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

//    Stop recording when the stopRecording button is pressed
    @IBAction func stopRecording(_ sender: UIButton) {
        updateUI(isRecording: false)
        audioRecorder.stop()
        try! audioSession.setActive(false)
    }
    
//    AVAudioRecorderDelegate function
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag
        {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else
        {
            print("Recording was not successful")
        }
    }
    
//    Pass the recorded audio to the second View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"
        {
            let changeSoundVC = segue.destination as! ChangeSoundViewController
            let recordedAudioURL = sender as! URL
            changeSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
}
