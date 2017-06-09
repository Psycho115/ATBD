//
//  SummaryCell.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/3/11.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class TextLabelCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: ExpandableLabel!
    
    override func awakeFromNib() {
        self.shadowCastView()
    }
    
    func display(title: String, detail: String) {
        self.title.text = title
        self.detail.text = detail
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        
        var newFrame = attr.frame
        self.frame = newFrame
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let desiredHeight: CGFloat = 200
        newFrame.size.height = desiredHeight

        attr.frame = newFrame
        return attr
    }

    
}
