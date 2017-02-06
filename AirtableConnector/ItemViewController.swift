//
//  ItemViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/31.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import ReachabilitySwift

class ItemViewController: UIViewController {
    
    var reachability = Reachability()!
    
    @IBOutlet weak var loadingBar: UIProgressView!
    
    @IBOutlet weak var tableViewContainer: UIView!
    var tableViewController: ItemTableViewController?
    
    func performUpdate() {
        self.tableViewController?.UpdateAirtable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //network checking
        self.reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if self.reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        
        self.reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                //self.navigationController.seg
                print("Not reachable")
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        //tableView
        self.tableViewContainer.addSubview(tableViewController!.view)
        
        //toolbar
        let imageView = UIImageView(image: #imageLiteral(resourceName: "ic_cached_white"))
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor.lightBlue
        let tapStepGestureRecognizer = UITapGestureRecognizer(target: self.tableViewController, action: #selector(ItemTableViewController.UpdateAirtable))
        imageView.addGestureRecognizer(tapStepGestureRecognizer)
        let barItem = UIBarButtonItem(customView: imageView)
        self.toolbarItems?.insert(barItem, at: 0)
        self.tableViewController?.toolbarSyncButton = barItem
        
        //loadingbar
        self.tableViewController?.loadingBar = self.loadingBar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItemsTable"
        {
            if let destinationVC = segue.destination as? ItemTableViewController {
                self.tableViewController = destinationVC
                self.tableViewController?.view.frame = tableViewContainer.bounds
            }
        }
    }

}
