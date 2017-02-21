//
//  CoverImageView.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/6.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import Alamofire

class CoverImageView: UIImageView {

    var spinner: UIActivityIndicatorView!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//        self.backgroundView = self.spinner
//        self.spinner.startAnimating()
//        
//        self.backgroundColor = UIColor.lightBlue
//        self.itemImageView.layer.masksToBounds = true
//        self.itemImageView.alpha = 0.0
//    }
    
    func displayImage(url: String) {
        Alamofire.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.image = image
                }
            case .failure(let error):
                print(error)
            }
        //self.image = image
//        if self.spinner.isAnimating {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.spinner.alpha = 0.0
//                self.alpha = 1.0
//            })
//            self.spinner.stopAnimating()
        }
    }

}
