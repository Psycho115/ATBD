//
//  ItemViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/31.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import ReachabilitySwift
import Jelly

class ItemViewController: UIViewController {
    
    var jellyAnimator: JellyAnimator?
    
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
        imageView.tintColor = tableType.tintColor()
        let tapStepGestureRecognizer = UITapGestureRecognizer(target: self.tableViewController, action: #selector(ItemTableViewController.UpdateAirtable))
        imageView.addGestureRecognizer(tapStepGestureRecognizer)
        let barItem = UIBarButtonItem(customView: imageView)
        self.toolbarItems?.insert(barItem, at: 0)
        self.tableViewController?.toolbarSyncButton = barItem
        
        //loadingbar
        self.tableViewController?.loadingBar = self.loadingBar
        
        //UI
        self.popoverButton.tintColor = tableType.tintColor()
        self.popoverAddButton.tintColor = tableType.tintColor()
        self.loadingBar.progressTintColor = tableType.tintColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: tableType.tintColor() as Any!]
        self.navigationController?.navigationBar.tintColor = tableType.tintColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Navigation
    
    // SortMenu
    
    @IBOutlet weak var popoverButton: UIBarButtonItem!
    
    @IBAction func popoverSortTable(sender: UIBarButtonItem) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SortMenuViewController") as! SortMenuViewController
        viewController.parentVC = self

        var presentation = JellySlideInPresentation()
        presentation.directionShow = .bottom
        presentation.directionDismiss = .bottom
        
        //size and postion
        let gap = 10
        let width = UIScreen.main.bounds.width - CGFloat(2*gap)
        presentation.widthForViewController = JellyConstants.Size.custom(value: width)
        presentation.heightForViewController = JellyConstants.Size.custom(value: 200)
        presentation.gapToScreenEdge = gap

        presentation.verticalAlignemt = .bottom
        presentation.backgroundStyle = .dimmed(alpha: 0.4)
        presentation.presentationCurve = .easeInEaseOut
        presentation.dismissComplete = {
            viewController.dismissComplete()
            self.tableViewController?.sortItems()
        }
        self.jellyAnimator = JellyAnimator(presentation:presentation)
        self.jellyAnimator?.prepare(viewController: viewController)
        self.present(viewController, animated: true, completion: nil)
    }
    
    // AddMenu
    
    @IBOutlet weak var popoverAddButton: UIBarButtonItem!
    
    @IBAction func popoverAddView(sender: UIBarButtonItem) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
        viewController.parentVC = self
        
        var presentation = JellyFadeInPresentation()
        presentation.duration = JellyConstants.Duration(rawValue: 0.2)!
        
        self.jellyAnimator = JellyAnimator(presentation: presentation)
        self.jellyAnimator?.prepare(viewController: viewController)
        self.present(viewController, animated: true, completion: nil)
    }


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
