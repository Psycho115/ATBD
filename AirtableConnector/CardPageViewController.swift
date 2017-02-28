//
//  CardPageViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/8.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class CardPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var itemList = [(Int, ItemBase)]()
    var startPageIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        // Do any additional setup after loading the view.
        self.setViewControllers([self.ViewControllerAtIndex(index: self.startPageIndex)!], direction: .forward, animated: true, completion: nil)
        
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
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return self.itemList.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return self.startPageIndex
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

