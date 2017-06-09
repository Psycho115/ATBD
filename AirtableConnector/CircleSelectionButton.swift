//
//  CircleSelectionButton.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/6/6.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class CircleSelectionButton: UIButton {
    
    open var highlightColor = UIColor.greyGreen.withAlphaComponent(0.7)
    
    override func awakeFromNib() {
        let size = self.frame.size.height * 0.1
        self.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = highlightColor
            } else {
                backgroundColor = UIColor.clear
            }
        }
    }

}
