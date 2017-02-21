//
//  DetailCardViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/6.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class DetailCardViewController: UIViewController {
    
    @IBOutlet weak var coverImage: CoverImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookmark: UIImageView!
    @IBOutlet weak var starStack: UIStackView!
    
    
    //model data
    var chosenItem = ItemBase()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookmark.tintColor = tableType.tintColor()
        self.starStack.tintColor = UIColor.orange
        self.coverImage.shadowCast()
        self.bookmark.shadowCast()
    }

    override func viewWillAppear(_ animated: Bool) {
        coverImage.displayImage(url: self.chosenItem.image)
        self.titleLabel.text = self.chosenItem.title
        let stars = Int(self.chosenItem.rating)
        let views = self.starStack.arrangedSubviews
        for index in 0..<(5 - Int(stars/2)) {
            views[index].isHidden = true
        }
        if stars % 2 == 0 {
            views[5].isHidden = true
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
