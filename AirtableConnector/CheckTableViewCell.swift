//
//  CheckTableViewCell.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/3.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit


enum CellType {
    case sort
    case section
}

class CheckTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkmark: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.checkmark.tintColor = UIColor.lightBlue
    }
    
    var cellType = CellType.section
    
    func display(title: String, cellType: CellType) {
        self.titleLabel.text = title
        self.cellType = cellType
        self.checkmark.isHidden = !((self.titleLabel.text == sortSetting.sectionType.typeStr()) || (self.titleLabel.text == sortSetting.sortType.typeStr()))
    }
    
    //true for is a sort cell, false for is a section cell

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
            self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            if self.cellType == .section {
                sortSetting.matchSection(str: self.titleLabel.text!)
            }
            if self.cellType == .sort {
                sortSetting.matchSort(str: self.titleLabel.text!)
            }
        }
        else {
            self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        // Configure the view for the selected state
        if highlighted {
            self.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1.0)
        }
        else {
            self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }

}
