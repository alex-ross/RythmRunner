//
//  ResultsViewController.swift
//  RythmRunner
//
//  Created by Jaime on 11/12/2018.
//  Copyright © 2018 phoenix. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.collectionView!.register(UINib(nibName: GraphCollectionViewCell.string, bundle: nil), forCellWithReuseIdentifier: GraphCollectionViewCell.string)
        self.collectionView!.register(UINib(nibName: BarsCollectionViewCell.string, bundle: nil), forCellWithReuseIdentifier: BarsCollectionViewCell.string)
        self.collectionView!.register(UINib(nibName: DataCollectionViewCell.string, bundle: nil), forCellWithReuseIdentifier: DataCollectionViewCell.string)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphCollectionViewCell.string,    for: indexPath) as! GraphCollectionViewCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BarsCollectionViewCell.string,    for: indexPath) as! BarsCollectionViewCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCollectionViewCell.string,    for: indexPath) as! DataCollectionViewCell
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if(isPortrait){
            return CGSize(width: UIScreen.main.bounds.width - 64, height: collectionView.bounds.height / 2)
        } else {
            return CGSize(width: UIScreen.main.bounds.width / 3, height: collectionView.bounds.height)
        }
        
    }
    
    var isPortrait : Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = isPortrait ? UICollectionView.ScrollDirection.vertical : UICollectionView.ScrollDirection.horizontal
        
    }

}
