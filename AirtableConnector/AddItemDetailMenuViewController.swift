//
//  DetailMenuViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/6/1.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class AddItemDetailMenuViewController: UIViewController {
    
    weak var parentVC: SearchResultViewController?
    
    var uniqueId = ""
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailButton.setImage(#imageLiteral(resourceName: "ic_details_36pt"), for: .normal)
        self.confirmButton.tintColor = UIColor.darkGray
        self.confirmButton.setImage(#imageLiteral(resourceName: "ic_check_white_48pt"), for: .normal)
        self.returnButton.tintColor = UIColor.darkGray
        self.returnButton.setImage(#imageLiteral(resourceName: "ic_arrow_back_36pt"), for: .normal)
    }
    
    @IBAction func detailButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        self.parentVC?.InsertItem(id: self.uniqueId)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func returnButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
