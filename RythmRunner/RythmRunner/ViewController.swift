//
//  ViewController.swift
//  rythmrunner
//
//  Created by Giada Rispoli on 11/12/2018.
//  Copyright © 2018 Giada Rispoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var HeartIcon: UIImageView!
    
    @IBOutlet weak var StartButton: UIButton!
    
    @IBOutlet weak var HistoryButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartButton.layer.cornerRadius = 32
        HistoryButton.layer.cornerRadius = 32
        // Do any additional setup after loading the view, typically from a nib.
    }


}

