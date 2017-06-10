//
//  ItemTableViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/28.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import CoreData
import NVActivityIndicatorView
import RainyRefreshControl
import PMAlertController
import Jelly

class ItemTableViewController: CoreDataTableViewController {
    
    var tableType = TableType.unsigned
    
    var coredataContext: NSManagedObjectContext? {
        didSet {
            updateUI()
        }
    }
    
    // Outlets
    var activityIndicatorView: NVActivityIndicatorView!
    var rainyRefreshControl: RainyRefreshControl?
    var toolbarSyncButton: UIBarButtonItem?
    
    // MARK: - main func
    public func updateUI() {
        if let context = coredataContext {
            let sortInfo = sortRequest()
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: sortInfo.0,
                managedObjectContext: context,
                sectionNameKeyPath: sortInfo.1,
                cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
    public func sortSettingsChanged() {
        if self.previousSortSetting == nil {
            return
        }
        if self.previousSortSetting! == sortSetting {
            return
        } else {
            self.previousSortSetting = sortSetting
        }
    }
    
    private func sortRequest() -> (NSFetchRequest<NSFetchRequestResult>, String?) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.tableType.entityName()!)
        request.predicate = nil
        
        var sortDescriptors = [NSSortDescriptor]()
        var sectionNameKey: String?
        switch sortSetting.sectionType {
        case .byMonth:
            sortDescriptors.append(NSSortDescriptor(key: "yearMonth", ascending: false))
            sectionNameKey = "yearMonth"
        case .byTitleFirstLetter:
            sortDescriptors.append(NSSortDescriptor(key: "firstLetter", ascending: true))
            sectionNameKey = "firstLetter"
        case .noSection:
            sectionNameKey = "noSectionName"
        }
        
        switch sortSetting.sortType {
        case .byRating:
            sortDescriptors.append(NSSortDescriptor(key: "rating", ascending: false))
        case .byTitle:
            sortDescriptors.append(NSSortDescriptor(key: "title", ascending: true))
        case .byTimeAdded:
            sortDescriptors.append(NSSortDescriptor(key: "dateAdded", ascending: false))
        case .byMyRating:
            sortDescriptors.append(NSSortDescriptor(key: "myRating", ascending: false))
        }
        
        request.sortDescriptors = sortDescriptors
        
        return (request,sectionNameKey)
    }
    
    public func tmpAddItems() {
        let bookList = [26729776, 26892080, 26698660, 26607924, 26357614]
        if let context = self.coredataContext {
            for id in bookList {
                _ = DBBookItem.InsertBookItem(id: String(id), inContext: context)
            }
        }
        let movieList = [26628357, 25921812, 25934014, 26022182, 21324900, 3434070, 26685451, 25980443, 26354572, 11526817, 26145033, 25765735]
        if let context = self.coredataContext {
            for id in movieList {
                _ = DBMovieItem.InsertMovieItem(id: String(id), inContext: context)
            }
        }
    }
    
    // MARK: - Update Controll
    
    private var itemsUpdated: Int = 0 {
        didSet {
            if itemsUpdated == self.fetchedResultsController?.fetchedObjects?.count {
                self.rainyRefreshControl?.endRefreshing()
                self.itemsUpdated = 0
            }
        }
    }
    
    func updateDBItems() {
        
        self.itemsUpdated = 0
        self.rainyRefreshControl?.beginRefreshing()
        
        for sec in 0..<self.numberOfSections(in: tableView) {
            for row in 0..<self.tableView(tableView, numberOfRowsInSection: sec) {
                let indexPath = IndexPath(row: row, section: sec)
                if let item = fetchedResultsController?.object(at: indexPath) as? DBItemBase {
                    item.updateItem(inContext: self.coredataContext, updateDidFinish: {
                        self.itemsUpdated += 1
                    })
                }
            }
        }
    }
    
    func deleteItem(item: NSManagedObject?) {
        if item != nil {
            self.coredataContext?.delete(item!)
            do {
                try self.coredataContext?.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveDataBase() {
        do {
            try self.coredataContext?.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        //loading indicator
        activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame)
        activityIndicatorView.type = .ballScaleRippleMultiple
        activityIndicatorView.color = self.tableType.tintColor()!
        activityIndicatorView.padding = CGFloat(160)
        tableView.backgroundView = activityIndicatorView
        
        //footer
        let cell = tableView.dequeueReusableCell(withIdentifier: "FooterView") as! FooterView
        let footerView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ItemTableViewController.scrollToTop))
        footerView.addSubview(cell)
        footerView.addGestureRecognizer(tap)
        self.tableView.tableFooterView = footerView
        
        let headerView = UIView()
        headerView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10)
        self.tableView.tableHeaderView = headerView
        
        //section index
        self.tableView.sectionIndexColor = self.tableType.tintColor()!
        self.tableView.sectionIndexBackgroundColor = UIColor.eggshell
        
        //refreshing
        self.refreshControl = nil
        self.rainyRefreshControl = RainyRefreshControl(themeColor: UIColor.greyGreen)
        self.rainyRefreshControl?.addTarget(self, action: #selector(ItemTableViewController.updateDBItems), for: .valueChanged)
        self.tableView.addSubview(self.rainyRefreshControl!)
        
        self.previousSortSetting = sortSetting
        
        //self.tableView.contentInset.top = 10

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: false)
    }

    // MARK: - Table view data source
    
    // Sort control
    
    private var previousSortSetting: SortSettings? {
        didSet {
            updateUI()
            tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    // TableView delegate
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        cell.initCell(source: fetchedResultsController?.object(at: indexPath) as? DBItemBase, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTitle: String?
        var count: Int?
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            sectionTitle = sections[section].name
            count = sections[section].objects?.count
        } else {
            sectionTitle = nil
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderView
        var countString: String?
        switch self.tableType {
        case .books:
            countString = "\(count!) 本"
        case .movies:
            countString = "\(count!) 部"
        default:
            countString = nil
        }
        cell.display(title: sectionTitle, count: countString)
        let view = UIView()
        view.addSubview(cell)
        
        return view
    }
    
    // Actions 
    
    var jellyAnimator: JellyAnimator?
    
    @IBAction func moreBurronPressed(_ sender: UIButton) {
        
        let cell = sender.superview?.superview as? ItemTableViewCell
        
        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailMenuViewController") as! DetailMenuViewController
        menuVC.parentVC = self
        menuVC.item = cell?.item as? NSManagedObject
        
        var presentation = JellySlideInPresentation()
        presentation.directionShow = .bottom
        presentation.directionDismiss = .bottom
        
        //size and postion
        let gap = 10
        let width = UIScreen.main.bounds.width - CGFloat(2*gap)
        presentation.widthForViewController = JellyConstants.Size.custom(value: width)
        presentation.heightForViewController = JellyConstants.Size.custom(value: 180)
        presentation.gapToScreenEdge = 2 * gap
        
        presentation.verticalAlignemt = .bottom
        presentation.backgroundStyle = .dimmed(alpha: 0.5)
        presentation.presentationCurve = .easeInEaseOut
        presentation.dismissComplete = nil
        self.jellyAnimator = JellyAnimator(presentation:presentation)
        self.jellyAnimator?.prepare(viewController: menuVC)
        self.present(menuVC, animated: true, completion: nil)
        
    }
    
    func scrollToTop() {
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCardPage"{
        }
    }


}


