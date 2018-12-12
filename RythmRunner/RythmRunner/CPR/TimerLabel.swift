//
//  TimerLabel.swift
//  RythmRunner
//
//  Created by Jaime on 12/12/2018.
//  Copyright © 2018 phoenix. All rights reserved.
//

import UIKit

class TimerLabel: UILabel{
   
    var seconds : Int? {
        didSet {
            guard let _ = seconds else { return }
            self.text = timeString(time: TimeInterval(seconds!))
        }
    }
   
    func timeString(time: TimeInterval) -> String {
        //  let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
}
