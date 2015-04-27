//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Patrick Hyland on 22/4/2015.
//  Copyright (c) 2015 WhipDev. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer : AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var error : NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error:&error)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        var session = AVAudioSession.sharedInstance()
        session.overrideOutputAudioPort( AVAudioSessionPortOverride.Speaker, error: nil) // to set output to bottom speakers

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func playSoundSlow(sender: UIButton) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = 0.5
        
        audioPlayer.play()
    }

    @IBAction func PlaySoundFast(sender: UIButton) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = 2.0
        
        audioPlayer.play()
    }
    @IBAction func StopPlaying(sender: UIButton) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func PlaySoundChipmunk(sender: UIButton) {
        playAudioWithVariablePitch( 1200 )
    }
    
    @IBAction func PlaySoundDarthVader(sender: UIButton) {
         playAudioWithVariablePitch( -1200 )
    }
    
    func playAudioWithVariablePitch( pitch: Float )
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    @IBAction func moreOptions(sender: UIButton) {
        performSegueWithIdentifier("PlayWithOptionsSegue", sender: receivedAudio)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PlayWithOptionsSegue")
        {
            let playSoundsWithOptionsVC:PlaySoundsWithMoreOptionsViewController = segue.destinationViewController as! PlaySoundsWithMoreOptionsViewController
            let data = sender as! RecordedAudio
            playSoundsWithOptionsVC.receivedAudio = data
        }
    }
   
}
