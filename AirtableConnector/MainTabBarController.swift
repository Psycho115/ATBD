//
//  MainTabBarController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/5/1.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let movieVC = viewControllers?[0] as? TableContainer {
            movieVC.tableType = .movies
        }
        
        if let bookVC = viewControllers?[1] as? TableContainer {
            bookVC.tableType = .books
        }
        
        self.tabBar.tintColor = UIColor.darkGray
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.shadowCastView()
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
