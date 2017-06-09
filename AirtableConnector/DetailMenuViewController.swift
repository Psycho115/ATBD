//
//  DetailMenuViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/6/1.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import CoreData
import Jelly
import SafariServices

class DetailMenuViewController: UIViewController {
    
    weak var parentVC: ItemTableViewController?
    var item: NSManagedObject?
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailButton.cornerRadius = detailButton.frame.size.height*0.5
        self.detailButton.tintColor = UIColor.darkGray
        self.detailButton.setImage(#imageLiteral(resourceName: "ic_details_36pt"), for: .normal)
        
        self.deleteButton.cornerRadius = deleteButton.frame.size.height*0.5
        self.deleteButton.tintColor = UIColor.darkGray
        self.deleteButton.setImage(#imageLiteral(resourceName: "ic_delete_forever_36pt"), for: .normal)
        
        self.returnButton.cornerRadius = returnButton.frame.size.height*0.5
        self.returnButton.tintColor = UIColor.darkGray
        self.returnButton.setImage(#imageLiteral(resourceName: "ic_arrow_back_36pt"), for: .normal)
        
        self.rateButton.cornerRadius = returnButton.frame.size.height*0.5
        self.rateButton.tintColor = UIColor.darkGray
        self.rateButton.setImage(#imageLiteral(resourceName: "ic_star_border"), for: .normal)
        
        self.dateButton.cornerRadius = returnButton.frame.size.height*0.5
        self.dateButton.tintColor = UIColor.darkGray
        self.dateButton.setImage(#imageLiteral(resourceName: "ic_date_range_36pt"), for: .normal)
        
        self.exportButton.cornerRadius = returnButton.frame.size.height*0.5
        self.exportButton.tintColor = UIColor.darkGray
        self.exportButton.setImage(#imageLiteral(resourceName: "ic_open_in_browser_36pt"), for: .normal)
    }
    
    @IBAction func detailButtonClicked(_ sender: UIButton) {

    }
    
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        
        let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationViewController") as! ConfirmationViewController
        confirmationVC.message = "确定删除？"
        
        var presentation = JellySlideInPresentation()
        presentation.directionShow = .bottom
        presentation.directionDismiss = .bottom
        
        //size and postion
        let gap = 10
        let width = UIScreen.main.bounds.width - CGFloat(2*gap)
        presentation.widthForViewController = JellyConstants.Size.custom(value: width)
        presentation.heightForViewController = JellyConstants.Size.custom(value: 135)
        presentation.widthForViewController = JellyConstants.Size.custom(value: 280)
        presentation.gapToScreenEdge = 2 * gap
        
        presentation.verticalAlignemt = .center
        presentation.backgroundStyle = .dimmed(alpha: 0.5)
        presentation.presentationCurve = .easeInEaseOut
        presentation.dismissComplete = {
            if confirmationVC.bResult {
                self.parentVC?.deleteItem(item: self.item)
            }
            self.parentVC?.dismiss(animated: true, completion: nil)
        }
        let jellyAnimator = JellyAnimator(presentation: presentation)
        jellyAnimator.prepare(viewController: confirmationVC)
        self.present(confirmationVC, animated: true, completion: nil)
    }
    
    @IBAction func returnButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateButtonClicked(_ sender: UIButton) {
        
        if let lItem = self.item as? DBItemBase {
            
            let ratingVC = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
            
            ratingVC.rating = lItem.getMyRating()
            
            var presentation = JellySlideInPresentation()
            presentation.directionShow = .bottom
            presentation.directionDismiss = .bottom
            
            //size and postion
            let gap = 10
            let width = UIScreen.main.bounds.width - CGFloat(2*gap)
            presentation.widthForViewController = JellyConstants.Size.custom(value: width)
            presentation.heightForViewController = JellyConstants.Size.custom(value: 120)
            presentation.gapToScreenEdge = 2 * gap
            
            presentation.verticalAlignemt = .bottom
            presentation.backgroundStyle = .dimmed(alpha: 0.5)
            presentation.presentationCurve = .easeInEaseOut
            presentation.dismissComplete = {
                lItem.rate(withRating: ratingVC.getRating())
                self.parentVC?.saveDataBase()
                self.dismiss(animated: true, completion: nil)
            }
            let jellyAnimator = JellyAnimator(presentation:presentation)
            jellyAnimator.prepare(viewController: ratingVC)
            self.present(ratingVC, animated: true, completion: nil)
            
        }
    }

    @IBAction func dateButtonClicked(_ sender: UIButton) {
        
        if let lItem = item as? DBItemBase {
            
            let datePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            
            var presentation = JellySlideInPresentation()
            presentation.directionShow = .bottom
            presentation.directionDismiss = .bottom
            
            //size and postion
            let gap = 10
            let width = UIScreen.main.bounds.width - CGFloat(2*gap)
            presentation.widthForViewController = JellyConstants.Size.custom(value: width)
            presentation.heightForViewController = JellyConstants.Size.custom(value: 300)
            presentation.gapToScreenEdge = 2 * gap
            
            presentation.verticalAlignemt = .bottom
            presentation.backgroundStyle = .dimmed(alpha: 0.5)
            presentation.presentationCurve = .easeInEaseOut
            presentation.dismissComplete = {
                lItem.setDate(date: datePickerVC.getSelectedDate())
                self.parentVC?.saveDataBase()
                self.dismiss(animated: true, completion: nil)
            }
            let jellyAnimator = JellyAnimator(presentation:presentation)
            jellyAnimator.prepare(viewController: datePickerVC)
            self.present(datePickerVC, animated: true, completion: nil)
            
            datePickerVC.setSelectedDate(setDate: lItem.getDate())
        }
    }

    @IBAction func exportButtonClicked(_ sender: UIButton) {
        
        let webVC = SFSafariViewController(url: URL(string: "http://www.baidu.com")!)
        webVC.view.cornerRadius = 4
        
        var presentation = JellySlideInPresentation()
        presentation.directionShow = .bottom
        presentation.directionDismiss = .bottom
        
        //size and postion
        let gap = 10
        let width = UIScreen.main.bounds.width - CGFloat(2*gap)
        presentation.widthForViewController = JellyConstants.Size.custom(value: width)
        presentation.heightForViewController = JellyConstants.Size.custom(value: 600)
        presentation.gapToScreenEdge = 2 * gap
        
        presentation.verticalAlignemt = .bottom
        presentation.backgroundStyle = .dimmed(alpha: 0.5)
        presentation.presentationCurve = .easeInEaseOut
        presentation.dismissComplete = nil
        let jellyAnimator = JellyAnimator(presentation: presentation)
        jellyAnimator.prepare(viewController: webVC)
        self.present(webVC, animated: true, completion: nil)
        
    }

}
