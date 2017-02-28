//
//  CardCollectionCell.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/25.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class CardCollectionCell: UICollectionViewCell {
    
    var themeColor = UIColor.white
    
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardIcon: UIImageView!
    @IBOutlet weak var cardIconBackground: UIView!
    
    public func initiate(image: UIImage, title: String, themeColor: UIColor) {
        self.cornerRadius = 5
        self.themeColor = themeColor
        self.cardIcon.image = image
        self.cardIcon.tintColor = UIColor.eggshell
        self.cardIconBackground.cornerRadius = 5
        self.cardIconBackground.backgroundColor = themeColor
        self.cardLabel.text = title
    }
    
    public func display(isHighlighted: Bool) {
        self.backgroundColor = isHighlighted ? themeColor.withAlphaComponent(0.4) : UIColor.clear
    }
    
}
