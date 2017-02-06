//
//  ImageTableViewCell.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/30.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import Alamofire

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    var spinner: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.backgroundView = self.spinner
        self.spinner.startAnimating()
        
        self.backgroundColor = UIColor.clear
        self.itemImageView.layer.masksToBounds = true
        self.itemImageView.alpha = 0.0
    }
    
    func displayImage(image: UIImage) {
        self.itemImageView.image = image
        if self.spinner.isAnimating {
            UIView.animate(withDuration: 0.3, animations: {
                self.spinner.alpha = 0.0
                self.itemImageView.alpha = 1.0
            })
            self.spinner.stopAnimating()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
