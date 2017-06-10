//
//  DetailMenuViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/6/1.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import SafariServices
import Jelly

class AddItemDetailMenuViewController: UIViewController {
    
    weak var parentVC: SearchResultViewController?
    
    var uniqueId = ""
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailButton.tintColor = UIColor.darkGray
        self.detailButton.setImage(#imageLiteral(resourceName: "ic_details_36pt"), for: .normal)
        self.confirmButton.tintColor = UIColor.darkGray
        self.confirmButton.setImage(#imageLiteral(resourceName: "ic_check_white_48pt"), for: .normal)
        self.returnButton.tintColor = UIColor.darkGray
        self.returnButton.setImage(#imageLiteral(resourceName: "ic_arrow_back_36pt"), for: .normal)
    }
    
    @IBAction func detailButtonClicked(_ sender: UIButton) {
        var url = "http://www.baidu.com"
        if let type = parentVC?.tableType {
            switch type {
            case .books:
                url = "https://m.douban.com/book/subject/" + uniqueId
            case .movies:
                url = "https://m.douban.com/movie/subject/" + uniqueId
            default:
                url = "http://www.baidu.com"
            }
        }
        
        let webVC = SFSafariViewController(url: URL(string: url)!)
        webVC.view.cornerRadius = 4
        
        var presentation = JellySlideInPresentation()
        presentation.directionShow = .bottom
        presentation.directionDismiss = .bottom
        
        //size and postion
        let gap = 10
        let width = UIScreen.main.bounds.width - CGFloat(2*gap)
        presentation.widthForViewController = JellyConstants.Size.custom(value: width)
        presentation.heightForViewController = JellyConstants.Size.custom(value: 500)
        presentation.gapToScreenEdge = 2 * gap
        
        presentation.verticalAlignemt = .bottom
        presentation.backgroundStyle = .dimmed(alpha: 0.5)
        presentation.presentationCurve = .easeInEaseOut
        presentation.dismissComplete = nil
        let jellyAnimator = JellyAnimator(presentation: presentation)
        jellyAnimator.prepare(viewController: webVC)
        self.present(webVC, animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        self.parentVC?.InsertItem(id: self.uniqueId)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func returnButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
