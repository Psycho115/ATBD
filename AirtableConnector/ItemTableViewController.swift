//
//  ItemTableViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/28.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RainyRefreshControl
import PMAlertController

class ItemTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var dataSource = ItemTableViewModel()
    
    // Outlets
    var activityIndicatorView: NVActivityIndicatorView!
    var rainyRefreshControl: RainyRefreshControl?
    var loadingBar: UIProgressView!
    var toolbarSyncButton: UIBarButtonItem?
    
    public func refresh() {
        self.rainyRefreshControl?.beginRefreshing()
        
        self.dataSource.clear()
        self.dataSource.retrieveItems()
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    public func UpdateAirtable() {
        
        if self.dataSource.fetchingProgress == 1.0 {
            if self.dataSource.TotalItemsToBeUpdated == 0 {
                let alertVC = PMAlertController(title: "内容未更改", description: "无需更新Airtable", image: nil, style: .alert)
                let action = PMAlertAction(title: "OK", style: .cancel, action: { () in
                    self.dismiss(animated: true)
                })
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            else {
                self.toolbarSyncButton?.customView?.startRotating(isClockwise: false)
            }
        } else {
            let alertVC = PMAlertController(title: "请稍后", description: "正在更新", image: nil, style: .alert)
            let action = PMAlertAction(title: "OK", style: .cancel, action: { () in
                self.dismiss(animated: true)
            })
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        for (section, itemsArray) in self.itemsSorted.enumerated() {
            for (row, item) in itemsArray.enumerated() {
                if item.1.updated {continue}
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? ItemTableViewCell
                cell?.startSyncronizing()
                
                let completionClosure = {
                    cell?.stopSyncronizing()
                    if self.dataSource.itemsRemainsToBeUpdated == 0 {
                        _ = self.toolbarSyncButton?.customView?.stopRotating()
                    }
                }
                self.dataSource.updateItem(index: item.0, completion: completionClosure)
            }
        }
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        //loading indicator
        activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame)
        activityIndicatorView.type = .ballScaleRippleMultiple
        activityIndicatorView.color = tableType.tintColor()!
        activityIndicatorView.padding = CGFloat(160)
        tableView.backgroundView = activityIndicatorView
        
        //add footer to delete singlelines
        self.tableView.tableFooterView = UIView()
        
        //section index
        self.tableView.sectionIndexColor = tableType.tintColor()!
        self.tableView.sectionIndexBackgroundColor = UIColor.eggshell
        
        //refreshing
        self.refreshControl = nil
        self.rainyRefreshControl = RainyRefreshControl(bgColor: tableType.tintColor()!)
        self.rainyRefreshControl?.addTarget(self, action: #selector(ItemTableViewController.refresh), for: .valueChanged)
        self.tableView.addSubview(self.rainyRefreshControl!)
        
        //model initiate
        self.dataSource.performWhenItemsDidSet = {
            self.loadingBar.setProgress(self.dataSource.fetchingProgress, animated: true)
            if self.dataSource.fetchingProgress != 1.0 { return }
            //change sortsetting to perform  sort
            self.previousSortSetting = sortSetting
        }
        let failedClosure = {
            self.loadingBar.setProgress(self.dataSource.fetchingProgress, animated: true)
            if self.dataSource.fetchingProgress != 1.0 { return }
            //change sortsetting to perform  sort
            self.previousSortSetting = sortSetting
        }
        self.dataSource.retrieveItems(failed: failedClosure)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.dataSource.items.count == 0) {
            activityIndicatorView.startAnimating()
        }
        
        self.sortItems()
    }

    // MARK: - Table view data source
    
    // Sort control
    
    private var sectionTitles = [String]()
    private var isSorted: Bool = false
    private var previousSortSetting: SortSettings? {
        didSet {
            performSortAction()
        }
    }
    
    private var itemsSorted = [[(Int, ItemBase)]]() {
        didSet{
            if !isSorted { return }
            if self.activityIndicatorView.isAnimating {
                UIView.animate(
                    withDuration: 0.8,
                    delay: 0.0,
                    options: [],
                    animations: {
                        self.activityIndicatorView.alpha = 0.0
                },
                    completion: {
                        if $0 {
                            self.activityIndicatorView.stopAnimating()
                            self.tableView.reloadData()
                            self.dismiss(animated: true)
                            self.loadingBar.dispear(finished: {
                                self.loadingBar.setProgress(0.0, animated: false)
                            })
                            self.navigationController?.setToolbarHidden(false, animated: true)
                        }
                })
            } else {
                self.rainyRefreshControl?.endRefreshing()
                self.tableView.reloadData()
                self.navigationController?.setToolbarHidden(false, animated: true)
                self.dismiss(animated: true)
            }
        }
    }
    
    public func sortItems() {
        if self.previousSortSetting == nil {
            return
        }
        if self.previousSortSetting! == sortSetting {
            if (self.navigationController?.isToolbarHidden)! {
                self.navigationController?.setToolbarHidden(false, animated: true)
            }
            return
        } else {
            self.previousSortSetting = sortSetting
        }
    }
    
    private func performSortAction() {
        
        self.isSorted = false
        self.itemsSorted.removeAll()
        self.sectionTitles.removeAll()
        
        var itemsSortedTmp = [[(Int, ItemBase)]]()
        
        let sets = self.generateSectionSets()
        var dict = self.generateSectionDict()
        
        for (_, key) in sets.enumerated() {
            self.sectionTitles.append(key.description)
            itemsSortedTmp.append(dict[key.description]!.sorted(by: {$0.1 < $1.1}))
        }
        
        //last modification
        self.isSorted = true
        self.itemsSorted = itemsSortedTmp
    }
    
    private func generateSectionSets() -> [String] {
        let undeletedItems = self.dataSource.items.filter( {!$0.deleted} )
        switch sortSetting.sectionType {
        case .byYear:
            return Set(undeletedItems.map{
                $0.getDateComponent(unit: .year).description
            }).sorted(by: {$0<$1})
        case .byMonth:
            return Set(undeletedItems.map{
                $0.getDateComponent(unit: .month).description
            }).sorted(by: {$0<$1})
        case .byTitleFirstLetter:
            return Set(undeletedItems.map{
                $0.title.transformToPinYin()[0]
            }).sorted(by: {$0<$1})
        case .noSection:
            return ["所有条目"]
        }
    }
    
    private func generateSectionDict() -> [String: [(Int, ItemBase)]] {
        var dict = [String: [(Int, ItemBase)]]()
        
        for (index, item) in self.dataSource.items.enumerated() {
            guard !item.deleted else { continue }
            let key: String
            switch sortSetting.sectionType {
            case .byYear:
                key = item.getDateComponent(unit: .year).description
            case .byMonth:
                key = item.getDateComponent(unit: .month).description
            case .byTitleFirstLetter:
                key = item.title.transformToPinYin()[0]
            case .noSection:
                key = "所有条目"
            }
            
            if dict[key] != nil {
                dict[key]!.append((index, item))
            }
            else {
                dict[key] = []
                dict[key]!.append((index, item))
            }
        }
        
        return dict
    }
    
    // TableView delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsSorted[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.itemsSorted.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        switch tableType {
        case .books:
            if let item = self.itemsSorted[indexPath.section][indexPath.row].1 as? BookItem {
                cell.displayCell(rating: item.rating, title: item.title, detail: "完成时间： \(item.strDateAdded)", isSynced: item.updated)
            }
        case .movies:
            if let item = self.itemsSorted[indexPath.section][indexPath.row].1 as? MovieItem {
                cell.displayCell(rating: item.rating, title: item.title, detail: "观看时间： \(item.strDateAdded)", isSynced: item.updated)
            }
        case .unsigned:
            break
        }
        cell.delegate = self
        return cell
    }
    
    // MARK: - Edit cells
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let iconHeight = self.tableView.rowHeight * 0.3
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) {action in
            let (index, _) = self.itemsSorted[indexPath.section][indexPath.row]
            if self.itemsSorted[indexPath.section].count == 1 {
                self.tableView.beginUpdates()
                self.itemsSorted.remove(at: indexPath.section)
                self.sectionTitles.remove(at: indexPath.section)
                self.tableView.deleteSections([indexPath.section], with: .left)
                self.tableView.endUpdates()
            } else {
                self.tableView.beginUpdates()
                self.itemsSorted[indexPath.section].remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                self.tableView.endUpdates()
            }
            self.dataSource.deleteItem(index: index)
            
        }
        deleteAction.backgroundColor = UIColor.lightRed
        deleteAction.image = #imageLiteral(resourceName: "ic_delete_forever_white").scaledToSize(newSize: CGSize(width: iconHeight, height: iconHeight))
        deleteAction.textColor = UIColor.white

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCardPage"{
            if let destinationVC = segue.destination as? CardPageViewController {
                if let cell = sender as? ItemTableViewCell{
                    let title = cell.titleLabel?.text
                    var sortedItemList = [(Int, ItemBase)]()
                    for section in self.itemsSorted {
                        sortedItemList.append(contentsOf: section)
                    }
                    if let index = sortedItemList.index(where: {$0.1.title == title}) {
                        destinationVC.itemList = sortedItemList
                        destinationVC.startPageIndex = index
                    }
                }
            }
        }
    }


}


