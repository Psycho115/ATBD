//
//  SearchTableViewCell.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/27.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var parentVC: AddItemTableViewController?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.separatorView.backgroundColor = tableType.tintColor()
        
        self.confirmationView.isHidden = true
        self.confirmationView.backgroundColor = tableType.tintColor()?.withAlphaComponent(0.7)
        
        self.confirmationButton.tintColor = UIColor.eggshell
        self.cancelButton.tintColor = UIColor.eggshell
        
        self.searchIcon.tintColor = tableType.tintColor()
    }
    
    public func display(title: String, detail: String) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            if self.confirmationView.isHidden {
                self.confirmationView.appear(duration: 0.1)
            }
        } else {
            if !self.confirmationView.isHidden {
                self.confirmationView.dispear(duration: 0.1)
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.confirmationView.dispear(duration: 0.1)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        print("\(titleLabel.text!) is added to airtable")
        self.confirmationView.changeColor(duration: 0.4, color: UIColor.lightGreen) {
            //self.confirmationView.dispear(finished: {
                self.parentVC?.dismiss(animated: true, completion: nil)
            //})
        }
    }

}
