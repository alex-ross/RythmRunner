//
//  BlowDetector.swift
//  RythmRunner
//
//  Created by Jaime on 12/12/2018.
//  Copyright © 2018 phoenix. All rights reserved.
//

import UIKit
import AVFoundation
import CoreAudio

protocol BlowDetectorDelegate: AVAudioRecorderDelegate {
    func detectedBlow()
}
class BlowDetector {

    var levelTimer = Timer()
    var lowPassResults: Double = 0.0
    
    var delegate: BlowDetectorDelegate?
    var recordingSession: AVAudioSession?
    var whistleRecorder: AVAudioRecorder?
    
    var isBlowing = false

    
    init() {
        
    }
    
    
    func start(){
       
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        let audioURL = self.getWhistleURL()
                        
                        let settings = [
                            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 12000,
                            AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                        ]
                        
                        do {
                            // 5
                            self.whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
                            self.whistleRecorder?.delegate = self.delegate
                            self.whistleRecorder?.prepareToRecord()
                            self.whistleRecorder?.isMeteringEnabled = true
                            self.whistleRecorder?.record()
                            self.levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(self.levelTimerCallback), userInfo: nil, repeats: true)
                            
                        } catch {
                            self.finish()
                        }
                    } else {
                        print("error")
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
  
    func finish(){
        whistleRecorder?.stop()
        whistleRecorder = nil
        levelTimer.invalidate()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getWhistleURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
    }
    
    //This selector/function is called every time our timer (levelTime) fires
    @objc func levelTimerCallback() {
        //we have to update meters before we can get the metering values
        whistleRecorder?.updateMeters()
        print("recording")
       
        //print to the console if we are beyond a threshold value. Here I've used -7
        if let value = whistleRecorder?.averagePower(forChannel: 0) {
            if value > -7 {
                if(!isBlowing){ self.delegate?.detectedBlow() }
                isBlowing = true
                print("DETECTEEEEED")
            } else { isBlowing = false }
        }
    }

}
