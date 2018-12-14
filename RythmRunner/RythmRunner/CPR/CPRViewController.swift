//
//  CPRViewController.swift
//  RythmRunner
//
//  Created by Jaime on 12/12/2018.
//  Copyright © 2018 phoenix. All rights reserved.
//

import UIKit
import AVFoundation

class CPRViewController: UIViewController, BlowDetectorDelegate {
    
    var systemSoundID: SystemSoundID = 1005
    //1040
    @IBOutlet weak var timerLabel: TimerLabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIndicatorLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var nextStatusButton: UIButton!
    
    @IBAction func nextStatusAction(_ sender: Any) {
        status = status?.next
    }
    
    var statusIndicator: Int? {
        didSet {
            if statusIndicator == 0 {
                blowDetector.finish()
                status = status?.next
            }
            statusIndicatorLabel.text = "\(statusIndicator!)" }
    }
    var status: Status? = .cpr {
        didSet {
            statusImageView.image = status?.image
            statusLabel.text = status?.text
            statusIndicator = status?.taps
            nextLabel.text = status!.next.text
            
            if statusIndicator == -1 {
                nextStatusButton.isHidden = false
                nextStatusButton.setTitle(status?.extra, for: .normal)
                extraInfoLabel.isHidden = true
                statusIndicatorLabel.isHidden = true
            } else {
                nextStatusButton.isHidden = true
                extraInfoLabel.isHidden = false
                statusIndicatorLabel.isHidden = false
                extraInfoLabel.text = status!.extra
            }
            
            if status == .breath {blowDetector.start()}
        }
    }

    var blowDetector = BlowDetector()
    func detectedBlow() { statusIndicator? -= 1 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        runTimer()
        status = .check
        nextStatusButton.layer.cornerRadius = 32
        blowDetector.delegate = self
        
        
    }
    
    var isRunning = false
    var timer = Timer()
    var seconds : Double? {
        didSet{
            timerLabel.seconds = seconds
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        blowDetector.finish()
        stop()
        status = .check
    }

}


//TIMER
extension CPRViewController {

    func stop() {
        timer.invalidate()
        isRunning = false
    }
    
    func reset() {
        stop()
        seconds = 0
    }
    
    func runTimer() {
        if isRunning {seconds =  0}
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            self.seconds? += 0.5
            if self.status == .cpr  {
               // AudioServicesPlaySystemSound(self.systemSoundID)
//                print(self.systemSoundID)
//                self.systemSoundID += 1
            }
            
        }
    }
}

//STATUS
extension CPRViewController {
    enum Status {
        case check, clear, cpr, breath
        var item: (text: String, image: UIImage?, taps: Int, extra: String){
            switch self {
                case .check: return (text: "Check if conscious or unconscious", image: UIImage(named: "Eye"), taps: -1, extra: "Next")
                case .clear: return (text: "Clear airways", image: UIImage(named: "Breath"), taps: -1, extra: "Next")
                case .cpr: return (text: "Chest Compressions", image: UIImage(named: "Heart"), taps: 30, extra: "Tap on the screen")
                case .breath: return (text: "Full Breaths", image: UIImage(named: "Breath"), taps: 2, extra: "Blow on the microphone")
            }
        }
        var text: String { return item.text }
        var image: UIImage? { return item.image }
        var taps: Int? { return item.taps }
        var extra: String { return item.extra }
        var next: Status{
            switch self {
                case .check: return .clear
                case .clear: return .cpr
                case .cpr: return .breath
                case .breath: return .cpr
            }
        }
    }
}



extension CPRViewController {
    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if status == .cpr {
            statusIndicator? -= 1
            animate(isHighlighted: true)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.statusImageView.transform  = .init(scaleX: 0.7, y: 0.7)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.statusImageView.transform  = .identity
            }, completion: completion)
        }
    }
}
