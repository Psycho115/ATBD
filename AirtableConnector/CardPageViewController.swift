//
//  CardPageViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/8.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import CoreData

class CardPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var itemList = [(Int, NSFetchRequestResult)]()
    var startPageIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        self.setViewControllers([self.ViewControllerAtIndex(index: self.startPageIndex)!], direction: .forward, animated: true, completion: nil)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = self.view.frame
        self.view.insertSubview(blurView, at: 0)
        self.addDismissButton()
    }
    
    private func addDismissButton() {
        let frame = self.view.frame
        let center = CGPoint(x: frame.size.width-50, y: 50)
        let button = UIButton(frame: CGRect(origin: center, size: CGSize(width: 30, height: 30)))
        button.setImage(#imageLiteral(resourceName: "ic_close_white_48pt"), for: .normal)
        button.tintColor = UIColor.eggshell
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
    }
    
    func dismissSelf() {
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0.0
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }

    //MARK: - Data Source
    
    private func ViewControllerAtIndex(index: Int) -> CardViewController? {
        
        if index >= 0 && index < self.itemList.count {
            let vc: CardViewController = self.storyboard?.instantiateViewController(withIdentifier: "CardViewController") as! CardViewController
            vc.chosenItem = self.itemList[index].1
            vc.index = index
            return vc
        } else {
            return nil
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CardViewController).index
        index -= 1
        return self.ViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CardViewController).index
        index += 1
        return self.ViewControllerAtIndex(index: index)
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

