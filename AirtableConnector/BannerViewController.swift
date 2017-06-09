//
//  BannerViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/5/1.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import Jelly

class BannerViewController: UIViewController {
    
    var tableType = TableType.unsigned
    
    @IBOutlet weak var bannerTitle: UILabel!
    @IBOutlet weak var sortIcon: UIButton!
    
    weak var tableVC: ItemTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.sortIcon.tintColor = UIColor.black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bannerTitle.adjustsFontSizeToFitWidth = true
        self.bannerTitle.text = self.tableType.nameTitle()
    }
    
    // MARK: - Popups
    
    var jellyAnimator: JellyAnimator?
    
    @IBAction func popoverSortTable(sender: UIButton) {
        let sortVC = self.storyboard?.instantiateViewController(withIdentifier: "SortViewController") as! SortMenuViewController
        
        var presentation = JellySlideInPresentation()
        presentation.directionShow = .bottom
        presentation.directionDismiss = .bottom
        
        //size and postion
        let gap = 10
        let width = UIScreen.main.bounds.width - CGFloat(2*gap)
        presentation.widthForViewController = JellyConstants.Size.custom(value: width)
        presentation.heightForViewController = JellyConstants.Size.custom(value: 260)
        presentation.gapToScreenEdge = 2 * gap
        
        presentation.verticalAlignemt = .bottom
        presentation.backgroundStyle = .dimmed(alpha: 0.5)
        presentation.presentationCurve = .easeInEaseOut
        presentation.dismissComplete = {
            sortVC.dismissComplete()
            self.tableVC?.sortSettingsChanged()
        }
        self.jellyAnimator = JellyAnimator(presentation:presentation)
        self.jellyAnimator?.prepare(viewController: sortVC)
        self.present(sortVC, animated: true, completion: nil)
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
