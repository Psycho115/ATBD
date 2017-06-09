//
//  RatingViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/5/30.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    public var rating: Float?
    
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.ratingView.tintColor = UIColor.orange
        self.ratingView.rating = rating ?? 0
    }
    
    func getRating() -> Float {
        return self.ratingView.rating
    }

}
