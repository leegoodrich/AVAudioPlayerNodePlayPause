//
//  ViewController.swift
//  AVAudioPlayerNodePlayPause
//
//  Created by Lee Goodrich on 8/22/14.
//  Copyright (c) 2014 Mastah Lee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioEngine : AVAudioEngine!
    var audioPlayer : AVAudioPlayerNode!
    var audioBufferPlayer : AVAudioPlayerNode!


    var audioFile : AVAudioFile!
    var audioBuffer : AVAudioPCMBuffer!

    /*
    This button starts the audio engine and plays an audio file. When the audio is paused, the engine continues to run. 
    
    Behavior observed when playing paused audio: audio resumes where it left off, but is preceded by silence that seems correlated to the amount of audio that has been played already.
    */
    @IBAction func playWithAVAudioFilePressed(sender: AnyObject) {
        if !audioEngine.running {
            audioEngine.startAndReturnError(nil)
        }

        if audioPlayer.playing {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }

    /*
    This button starts the audio engine and plays a PCM audio buffer that has had the entire file read into it. When audio is paused, engine contines to run. 
    
    Behavior observed when playing paused audio: starts again immediately, but from the beginning of the file.
    */
    @IBAction func playWithAVAudioPCMBufferPressed(sender: AnyObject) {
        if !audioEngine.running {
            audioEngine.startAndReturnError(nil)
        }

        if audioBufferPlayer.playing {
            audioBufferPlayer.pause()
        } else {
            audioBufferPlayer.play()
        }

    }

    /*
    This button starts the audio engine and plays an audio file. When audio is paused, the engine is stopped, so it must be restarted when playback is resumed. 
    
    Behavior observed when playing paused audio: resumes audio where it left off with no delay.
    */
    @IBAction func playWithAVAudioFileWithEngineRestartPressed(sender: AnyObject) {
        if !audioEngine.running {
            audioEngine.startAndReturnError(nil)
        }
        
        if audioPlayer.playing {
            audioPlayer.pause()
            audioEngine.stop()
        } else {
            audioPlayer.play()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        audioEngine = AVAudioEngine()

        audioPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayer)

        audioBufferPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(audioBufferPlayer)

        audioFile = AVAudioFile(forReading: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("I.Allegro", ofType: "mp3")), error: nil)
        audioBuffer = AVAudioPCMBuffer(PCMFormat: audioFile.processingFormat, frameCapacity: UInt32(audioFile.length))
        audioFile.readIntoBuffer(audioBuffer, error: nil)

        audioEngine.connect(audioPlayer, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
        audioEngine.connect(audioBufferPlayer, to: audioEngine.mainMixerNode, format: audioBuffer.format)

        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioBufferPlayer.scheduleBuffer(audioBuffer, completionHandler: nil)
    }

}

