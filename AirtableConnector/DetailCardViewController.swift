//
//  DetailCardViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/6.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import CoreData

class DetailCardViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var colors: UIImageColors?
    var image: UIImage?
    
    //model data
    var chosenItem: NSFetchRequestResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ShowDetailViewController))
        self.view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        switch tableType {
        case .books:
            if let item = self.chosenItem as? DBBookItem {
                self.titleLabel.text = item.title
            }
        case .movies:
            if let item = self.chosenItem as? DBMovieItem {
                self.titleLabel.text = item.title
            }
        case .unsigned:
            break
        }
    }
    
    // segue
    func preSetData(image: UIImage) {
        self.image = image
        self.colors = image.getColors()
    }
    
    func ShowDetailViewController() {
        if let parent = self.parent as? CardViewController {
            parent.ShowDetailViewController()
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}
