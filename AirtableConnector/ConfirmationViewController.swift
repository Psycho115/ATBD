//
//  ConfirmationViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/6/6.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    weak var parentVC: ItemTableViewController?
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var alertMessageLabel: UILabel!
    
    var message: String?
    
    open var bResult = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertMessageLabel.text = message
        
        self.yesButton.cornerRadius = yesButton.frame.size.height*0.5
        self.yesButton.tintColor = UIColor.lightRed
        self.yesButton.setImage(#imageLiteral(resourceName: "ic_check_white_48pt"), for: .normal)
        
        self.noButton.cornerRadius = noButton.frame.size.height*0.5
        self.noButton.tintColor = UIColor.darkGray
        self.noButton.setImage(#imageLiteral(resourceName: "ic_arrow_back_36pt"), for: .normal)
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        bResult = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        bResult = false
        self.dismiss(animated: true, completion: nil)
    }

}
