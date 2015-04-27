//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Patrick Hyland on 21/4/2015.
//  Copyright (c) 2015 WhipDev. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var bRecordingPaused:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.hidden = true
        pauseButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap to record"
        bRecordingPaused = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
      
        //update UI
        stopRecordingButton.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false
        
        
        recordingInProgress.hidden = false
        recordingInProgress.text = "recording in progress..."
        
        
        if (!bRecordingPaused)
        {
            //record audio
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(sender: UIButton) {
        // stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        //update UI
        //actually we will update UI in viewWillAppear because after stopRecording is pressed we segue to new view - if we update UI now then user sees UI change briefly before segue
        //viewWIllAppear is called when this view is presented again after playSoundsViewController
    }
    
    
    @IBAction func pauseRecording(sender: UIButton) {
        
        audioRecorder.pause()
        
        //UI
        pauseButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap to continue recording"
        bRecordingPaused = true
        
    }
    
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag
        {
            //save recorded audio
            recordedAudio = RecordedAudio( filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            
            // segue
            performSegueWithIdentifier("StopRecording", sender: recordedAudio)
        }
        else
        {
            println("Recording was not successful")
            recordButton.enabled = true
            recordButton.hidden = false      
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}

