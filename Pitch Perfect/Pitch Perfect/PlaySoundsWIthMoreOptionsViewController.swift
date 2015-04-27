//
//  PlaySoundsWIthMoreOptionsViewController.swift
//  Pitch Perfect
//
//  Created by Patrick Hyland on 27/4/2015.
//  Copyright (c) 2015 WhipDev. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsWithMoreOptionsViewController: UIViewController {

    
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var echoSlider: UISlider!
    @IBOutlet weak var reverbSlider: UISlider!
    
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        var session = AVAudioSession.sharedInstance()
        session.overrideOutputAudioPort( AVAudioSessionPortOverride.Speaker, error: nil) // to set output to bottom speakers

    }
    
    override func viewWillAppear(animated: Bool) {
        rateSlider.value = 0.0 // -1 to +1
        pitchSlider.value = 0.0 // -1 to +1
        echoSlider.value = 0.0 // 0 - 1
        reverbSlider.value = 0.0 // 0 - 1
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

    @IBAction func playWithOptions(sender: UIButton) {
        

        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.rate = pow( 4.0 , rateSlider.value) // should be 32.0 but playback is to slow or fast at extreme values
        var pitch : Float
        if ( pitchSlider.value >= 0)
        {
            pitch = pitchSlider.value * 2399 + 1
        }
        else
        {
            pitch = pitchSlider.value * 2400
        }
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        var echoEffect = AVAudioUnitDistortion()
        echoEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho2)
        echoEffect.wetDryMix = echoSlider.value * 100.0
        audioEngine.attachNode(echoEffect)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = reverbSlider.value * 100.0
        audioEngine.attachNode(reverbEffect)
        
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
        
    }
   
}
