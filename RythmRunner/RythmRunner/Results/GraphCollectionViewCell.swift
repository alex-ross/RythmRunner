//
//  GraphCollectionViewCell.swift
//  RythmRunner
//
//  Created by Jaime on 11/12/2018.
//  Copyright © 2018 phoenix. All rights reserved.
//

import UIKit

class GraphCollectionViewCell: UICollectionViewCell {

    static var string = String(describing: GraphCollectionViewCell.self)
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


class GraphView : UIView {
    
    var layers: [CAShapeLayer?] = [CAShapeLayer?]()
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let array : [CGFloat] = [113, 104, 122, 123, 106, 96, 104, 100]
        let minimun = min(array.min() ?? 100, 100)
        let maximum = max(array.max() ?? 120, 120)
        func height(_ value: CGFloat) -> CGFloat {
            let percentage =  (value - minimun) / (maximum - minimun)
            return percentage * self.bounds.height
        }
        let margin: CGFloat = 10
        let width = (self.bounds.width - 2 * margin) / (array.count - 1)
        
        self.layers.forEach{ $0?.removeFromSuperlayer() }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: margin, y: height(array.first!) ))
        for (index, value) in array.enumerated() {
            path.addLine(to: CGPoint(x: margin + width * index, y: height(value)))
        }
    
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = UIColor(0xD30446).cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.path = path.cgPath
        
//        211
//        4
//        70
        createLine(y: height(120))
        createLine(y: height(100))
        
        // animate it
        
        layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 2
        shapeLayer.add(animation, forKey: "MyAnimation")
        
        // save shape layer
        
        self.layers.append(shapeLayer)
        
    }
    
    
    func createLine(y: CGFloat){
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0 , y: y))
        linePath.addLine(to: CGPoint(x: self.bounds.width, y: y))
        let line = CAShapeLayer()
        line.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        line.strokeColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1).cgColor
        line.lineWidth = 1
        line.path = linePath.cgPath
        layer.addSublayer(line)
        self.layers.append(line)
    }
    
    
}

