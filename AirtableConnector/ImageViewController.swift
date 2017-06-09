//
//  ImageViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/3/9.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    weak var parentVC: CardViewController?
    
    @IBOutlet weak var image: CoverImageView!
    
    var imageUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: parentVC, action: #selector(CardViewController.expandDetailCard))
        self.image.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = self.imageUrl {
            self.image.displayImageAndGetColors(url: url, completion: { (_) in
                self.parentVC?.cardViewController?.preSetData(image: self.image.getImage()!)
            })
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
