//
//  TableContainer.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/5/1.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import CoreData

class TableContainer: UIViewController {
    
    private var coredataContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    @IBOutlet weak var tableContainer: UIView!
    weak var tableViewController: ItemTableViewController?
    
    @IBOutlet weak var bannerContainer: UIView!
    weak var bannerViewController: BannerViewController?
    
    var tableType = TableType.unsigned

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableContainer.addSubview(self.tableViewController!.view)
        self.bannerContainer.addSubview(self.bannerViewController!.view)
        
        self.bannerViewController?.tableVC = self.tableViewController
        
        //self.bannerContainer.shadowCastView(offsetHeight: 5, radius: 3, color: UIColor.black, shadowOpacity: 0.03)
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbeddedTableView" {
            if let destinationVC = segue.destination as? ItemTableViewController{
                self.tableViewController = destinationVC
                self.tableViewController?.tableType = self.tableType
                self.tableViewController?.view.frame = tableContainer.bounds
                self.tableViewController?.coredataContext = self.coredataContext
            }
        }
        if segue.identifier == "EmbeddedBanner" {
            if let destinationVC = segue.destination as? BannerViewController{
                self.bannerViewController = destinationVC
                self.bannerViewController?.tableType = self.tableType
                self.bannerViewController?.view.frame = bannerContainer.bounds
            }
        }
    }


}
