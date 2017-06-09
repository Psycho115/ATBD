//
//  CustumUIViews.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/3/11.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class StackLabelView: UIStackView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var originTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var secondary: UILabel!
    
    

    public func display(title: String?, secondary: String?, originTitle: String?, date: NSDate?) {
        self.title.text = title
        self.originTitle.text = originTitle
        self.secondary.text = secondary
        
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            self.date.text = dateFormatter.string(from: date! as Date)
        }
    }
    
}

class CurvedBackgroundView: UIView {
    
    var color: UIColor = .eggshell
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // upper left corner
        let height1 = self.frame.size.height*0.4
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 0))
        path1.addLine(to: CGPoint(x: 0, y: height1))
        path1.addCurve(to: CGPoint(x: height1, y: 0),
                       controlPoint1: CGPoint(x: height1/2.0, y: height1*0.75),
                       controlPoint2: CGPoint(x: height1*0.75, y: height1/2.0))
        path1.close()
        
        // center 
        let width2 = self.frame.size.width*0.6
        let height2 = self.frame.size.height*0.5
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.66*frame.size.width, y: 0.0))
        path.addCurve(to: CGPoint(x: 0.3*frame.size.width, y: frame.size.height),
                      controlPoint1: CGPoint(x: 0.4*frame.size.width, y: 20.0),
                      controlPoint2: CGPoint(x: 0.5*frame.size.width, y: frame.size.height*0.7))
        path.addLine(to: CGPoint(x: width2, y: height2*2))
        path.addCurve(to: CGPoint(x: frame.size.width, y: height2*0.8),
                       controlPoint1: CGPoint(x: width2+50, y: height2*2),
                       controlPoint2: CGPoint(x: frame.size.width-50.0, y: height2))
        path.addLine(to: CGPoint(x: frame.size.width, y: 0.0))
        path.close()
        
        // lower right corner
        
        
        
        self.color.setFill()
        path1.fill()
        path.fill()
    }
    
}
