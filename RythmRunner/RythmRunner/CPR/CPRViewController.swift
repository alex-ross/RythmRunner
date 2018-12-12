//
//  CPRViewController.swift
//  RythmRunner
//
//  Created by Jaime on 12/12/2018.
//  Copyright © 2018 phoenix. All rights reserved.
//

import UIKit


class CPRViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: TimerLabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIndicatorLabel: UILabel!
    
    var statusIndicator: Int? {
        didSet {
            if statusIndicator == 0 { nextStatus() }
            statusIndicatorLabel.text = "\(statusIndicator!)" }
    }
    var status: Status? = .cpr {
        didSet {
            statusImageView.image = status?.image
            statusLabel.text = status?.text
            statusIndicator = status?.taps
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        runTimer()
        status = .cpr
        
    }
    
    
    func nextStatus() {
        switch status {
            case .cpr?: status = .breath
        default: break
        }
    }
    
    var isRunning = false
    var timer = Timer()
    var seconds : Int? {
        didSet{
            timerLabel.seconds = seconds
        }
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in self.seconds? += 1 }
    }
}

//STATUS
extension CPRViewController {
    enum Status {
        case cpr, breath, swap
        var item: (text: String, image: UIImage?, taps: Int){
            switch self {
            case .cpr: return (text: "Chest Compressions", image: UIImage(named: "Heart"), taps: 30)
            case .breath: return (text: "Full Breaths", image: UIImage(named: "Breath"), taps: 2)
            case .swap: return (text: "Swap CPR performer", image: UIImage(), taps: 1)
            }
        }
        var text: String { return item.text }
        var image: UIImage? { return item.image }
        var taps: Int? { return item.taps }
    }
}


extension CPRViewController {
    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if status == .cpr {statusIndicator? -= 1}
        animate(isHighlighted: true)
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
