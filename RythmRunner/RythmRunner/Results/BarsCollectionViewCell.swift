//
//  BarsCollectionViewCell.swift
//  RythmRunner
//
//  Created by Jaime on 12/12/2018.
//  Copyright © 2018 phoenix. All rights reserved.
//

import UIKit

class BarsCollectionViewCell: UICollectionViewCell {
    
    static var string = String(describing: BarsCollectionViewCell.self)
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }

}



class BarView : UIView {
    
    var layers: [CAShapeLayer?] = [CAShapeLayer?]()
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        let array : [CGFloat] = [3.2, 0, 0.5, 1.4, 1.5, 1.9, 1.7, 2.1]
        let minimun = min(array.min() ?? 0, 0)
        let maximum = max(array.max() ?? 2, 2)
        func height(_ value: CGFloat) -> CGFloat {
            let percentage =  (value - minimun) / (maximum - minimun)
            return percentage * self.bounds.height
        }
        let margin: CGFloat = 10
        let width = (self.bounds.width - 2 * margin) / (array.count)
        
        
        self.layers.forEach{ $0?.removeFromSuperlayer() }
    
       
        for (index, value) in array.enumerated() {
            addBar(x: margin + width * index, height: height(value), width: width)
        }
        
        createLine(y: height(2))
        
        // animate it
        
      
        
    }
    
    func addBar(x: CGFloat, height: CGFloat, width: CGFloat){
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: self.bounds.height + 30))
        path.addLine(to: CGPoint(x: x + width - 5, y: self.bounds.height + 30))
        path.addLine(to: CGPoint(x: x + width - 5, y: self.bounds.height - height))
        path.addLine(to: CGPoint(x: x, y: self.bounds.height - height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor(0xD30446).cgColor
        shapeLayer.strokeColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.path = path.cgPath
        shapeLayer.masksToBounds = false
        
        layer.addSublayer(shapeLayer)
        let animation = CASpringAnimation(keyPath: "position.y")
        animation.fromValue = self.bounds.height + height*5
        animation.toValue = 0
        animation.duration = 3
        shapeLayer.add(animation, forKey: "A\(x)")
        
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

