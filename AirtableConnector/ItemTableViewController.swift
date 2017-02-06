//
//  ItemTableViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/28.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import ReachabilitySwift

class ItemTableViewController: UITableViewController {
    
    let reachability = Reachability()!
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    var toolbarSyncButton: UIBarButtonItem?

    var apiKey = "key8n8MkjeRV8cJCO"
    
    var totalRecordsOnAirtable: Int = 0
    
    var TotalItemsToBeUpdated: Int {
        get {
            let value = self.items.filter({ !($0.updated) }).count
            self.itemsRemainsToBeUpdated = value
            return value
        }
    }
    var itemsRemainsToBeUpdated = 0
    
    var idDict = [String: (String, String, Bool)]()
    
    var items = [ItemBase]() {
        didSet{
            self.loadingBar.setProgress(self.fetchingProgress, animated: true)
            if self.fetchingProgress != 1.0 { return }
            //change sortsetting to perform  sort
            self.previousSortSetting = sortSetting
        }
    }
    
    var fetchingProgress: Float {
        get {
            if self.totalRecordsOnAirtable == 0 {
                return 0.0
            } else {
                return Float(self.items.count) / Float(totalRecordsOnAirtable)
            }
        }
    }
    
    func refresh() {
        
        self.totalRecordsOnAirtable = 0
        self.idDict.removeAll()
        self.items.removeAll()
        
        self.itemsSorted = [[]]
        let sections = IndexSet(integersIn: 0..<(self.itemsSorted.count))
        self.tableView.reloadSections(sections, with: .fade)
        
        self.loadingBar.appear(finished: {
            self.retrieveItems()
            self.navigationController?.setToolbarHidden(true, animated: true)
        })
    }
    
    func retrieveItems() {
        
        let authHeader: HTTPHeaders = ["Authorization": "Bearer \(apiKey)"]
        
        Alamofire.request(tableType.mainUrl()!, method: .get, headers: authHeader)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if self.idDict.count != 0 {
                        self.idDict.removeAll()
                    }
                    let swiftyJson = JSON(value)
                    self.totalRecordsOnAirtable = swiftyJson["records"].count
                    for (_,subJson):(String, JSON) in swiftyJson["records"]{
                        let doubanID = subJson["fields"]["ID"].stringValue
                        let completed: Bool
                        if let _ = subJson["fields"]["Title"].string {
                            completed = true
                            self.items.append(self.newItemFromAirtableJSON(swiftyJson: subJson))
                        } else { completed = false }
                        self.idDict[doubanID] = (subJson["id"].stringValue, subJson["fields"]["Time Added"].stringValue, completed)
                    }
                    self.getDoubanItems()
                case .failure(let error):
                    if self.activityIndicatorView.isAnimating {
                        self.activityIndicatorView.stopAnimating()
                    }
                    self.loadingBar.progressTintColor = UIColor.red
                    self.loadingBar.setProgress(1.0, animated: false)
                    self.loadingBar.dispear()
                    print("Failed to connect to airtable API")
                    print(error)
                }
            }
    }
    
    private func getDoubanItems(){
        
        let base_url = tableType.doubanUrl()!
    
        for (douban_id, (airtableID, dateAdded, completed)) in self.idDict {
            if completed { continue }
            //retreive from douban
            Alamofire.request(base_url+douban_id)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let swiftyJson = JSON(value)
                        let douban_item = self.newItemFromDoubanJSON(doubanID: douban_id, airtableID: airtableID, dateAdded: dateAdded, swiftyJson: swiftyJson)
                        self.items.append(douban_item)
                    case .failure( _):
                        if self.activityIndicatorView.isAnimating {
                            self.activityIndicatorView.stopAnimating()
                        }
                        self.loadingBar.progressTintColor = UIColor.red
                        self.loadingBar.setProgress(1.0, animated: true)
                        self.loadingBar.dispear()
                        print("Failed to connect to douban API")
                    }
            }
        }
    }
    
    private func newItemFromDoubanJSON(doubanID: String, airtableID: String, dateAdded: String, swiftyJson: JSON) -> ItemBase {
        let item: ItemBase
        switch tableType {
        case .books:
            //authors
            let authorsArray =  swiftyJson["author"].arrayValue.map({$0.stringValue})
            let authors = authorsArray.joined(separator: ", ")
            //set value
            let title = swiftyJson["title"].stringValue
            let rating = Double(swiftyJson["rating"]["average"].stringValue)!
            let cover = swiftyJson["images"]["large"].stringValue
            let isbn = Int(swiftyJson["isbn13"].stringValue)!
            item = BookItem(updated: false, doubanID: doubanID, title: title, author: authors, rating: rating, cover: cover, isbn: isbn, airtableID: airtableID, dateAdded: dateAdded)
        case.movies:
            //directors
            let directorsArray =  swiftyJson["directors"].arrayValue.map({$0["name"].stringValue})
            let directors = directorsArray.joined(separator: ", ")
            //actors
            let actorsArray =  swiftyJson["casts"].arrayValue.map({$0["name"].stringValue})
            let actors = actorsArray.joined(separator: ", ")
            //set value
            let title = swiftyJson["title"].stringValue
            let rating = Double(swiftyJson["rating"]["average"].stringValue)!
            let poster = swiftyJson["images"]["large"].stringValue
            item = MovieItem(updated: false, doubanID: doubanID, title: title, directors: directors, rating: rating, poster: poster, actors: actors, airtableID: airtableID, dateAdded: dateAdded)
        case .unsigned:
            item = ItemBase()
        }
        print("\(item.title) added from douban!")
        return item
    }
    
    private func newItemFromAirtableJSON(swiftyJson: JSON) -> ItemBase {
        let item: ItemBase
        switch tableType {
        case .books:
            let doubanID = swiftyJson["fields"]["ID"].stringValue
            let title = swiftyJson["fields"]["Title"].stringValue
            let authors = swiftyJson["fields"]["Author"].stringValue
            let rating = swiftyJson["fields"]["Rating"].doubleValue
            let cover = swiftyJson["fields"]["Cover"][0]["url"].stringValue
            let isbn = swiftyJson["fields"]["ISBN"].intValue
            let airtableID = swiftyJson["id"].stringValue
            let dateAdded = swiftyJson["fields"]["Time Added"].stringValue
            item = BookItem(updated: true, doubanID: doubanID, title: title, author: authors, rating: rating, cover: cover, isbn: isbn, airtableID: airtableID, dateAdded: dateAdded)
        case.movies:
            let doubanID = swiftyJson["fields"]["ID"].stringValue
            let title = swiftyJson["fields"]["Title"].stringValue
            let directors = swiftyJson["fields"]["Directors"].stringValue
            let rating = swiftyJson["fields"]["Rating"].doubleValue
            let poster = swiftyJson["fields"]["Poster"][0]["url"].stringValue
            let actors = swiftyJson["fields"]["Actors"].stringValue
            let airtableID = swiftyJson["id"].stringValue
            let dateAdded = swiftyJson["fields"]["Time Added"].stringValue
            item = MovieItem(updated: true, doubanID: doubanID, title: title, directors: directors, rating: rating, poster: poster, actors: actors, airtableID: airtableID, dateAdded: dateAdded)
        case .unsigned:
            item = ItemBase()
        }
        print("\(item.title) added from airtable!")
        return item
    }
        
    var loadingBar: UIProgressView!
    
    func UpdateAirtable() {
        
        if self.fetchingProgress == 1.0 {
            if self.TotalItemsToBeUpdated == 0 {
                let alertController = UIAlertController(title: "内容未更改", message: "无需更新Airtable", preferredStyle: UIAlertControllerStyle.alert)
                let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
                    self.dismiss(animated: true)
                }
                alertController.addAction(dismissAction)
                self.present(alertController, animated: true)
                return
            }
            else {
                self.toolbarSyncButton?.customView?.startRotating(isClockwise: false)
            }
        } else {
            let alertController = UIAlertController(title: "请稍后", message: "列表加载中", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alertController, animated: true)
            return
        }
        
        for (section, itemsArray) in self.itemsSorted.enumerated() {
            for (row, item) in itemsArray.enumerated() {
                if item.updated {continue}
                //            let patch_data = item.getItemJson()
                //            let authHeader: HTTPHeaders = ["Authorization": "Bearer \(apiKey)"]
                //            if let patchUrl = self.table.mainUrl() {
                //                Alamofire.request(patchUrl+"/"+item.airtableID, method: .patch, parameters: patch_data, encoding: JSONEncoding.default, headers: authHeader).responseJSON { response in
                //                    switch response.result {
                //                    case .success( _):
                //                        item.updated = true
                //                        print("\(item.title) updated")
                //                        self.tableView.reloadData()
                //                    case .failure( _):
                //                        print("Failed to connect to airtable API")
                //                    }
                //                }
                //            }
                if let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? ItemTableViewCell {
                    cell.startSyncronizing()
                }
                Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timerFireMethod), userInfo: IndexPath(row: row, section: section), repeats: false);
            }
        }
        
    }
    
    func timerFireMethod(timer:Timer) {
        let path = timer.userInfo as! IndexPath
        let item = self.itemsSorted[path.section][path.row]
        item.updated = true
        self.itemsRemainsToBeUpdated -= 1
        if let cell = self.tableView.cellForRow(at: path) as? ItemTableViewCell {
            cell.stopSyncronizing()
        }
        print("\(item.title) updated")
        //self.tableView.reloadData()
        if self.itemsRemainsToBeUpdated == 0 {
            _ = self.toolbarSyncButton?.customView?.stopRotating()
        }
    }
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading indicator
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicatorView
        
        //add footer to delete singlelines
        self.tableView.tableFooterView = UIView()
        
        //refreshing
        self.refreshControl?.addTarget(self, action: #selector(ItemTableViewController.refresh), for: UIControlEvents.valueChanged)
        
        retrieveItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.items.count == 0) {
            activityIndicatorView.startAnimating()
        }
        
        self.sortItems()
    }

    // MARK: - Table view data source
    
    //data source for table cells
    var itemsSorted = [Array<ItemBase>()] {
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
                            let sections = IndexSet(integersIn: 0..<(self.itemsSorted.count))
                            self.tableView.reloadSections(sections, with: .fade)
                            self.dismiss(animated: true)
                            self.loadingBar.dispear(finished: {
                                self.loadingBar.setProgress(0.0, animated: false)
                            })
                            self.navigationController?.setToolbarHidden(false, animated: true)
                        }
                }
                )
            } else if (self.refreshControl?.isRefreshing)! {
                self.loadingBar.dispear(finished: {
                    self.loadingBar.setProgress(0.0, animated: false)
                    let sections = IndexSet(integersIn: 0..<(self.itemsSorted.count))
                    self.tableView.reloadSections(sections, with: .fade)
                    self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.refreshControl?.endRefreshing()
                    self.navigationController?.setToolbarHidden(false, animated: true)
                    self.dismiss(animated: true)
                })
            } else {
                let sections = IndexSet(integersIn: 0..<(self.itemsSorted.count))
                self.tableView.reloadSections(sections, with: .fade)
                //scroll to top
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
    
    var isSorted: Bool = false
    var previousSortSetting: SortSettings? {
        didSet {
            performSortAction()
        }
    }
    
    func sortItems() {
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
        
        //last modification
        self.isSorted = true
        self.itemsSorted.append(self.items.sorted(by: { $0 < $1 }))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsSorted[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.itemsSorted.first?.first?.title ?? ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        switch tableType {
        case .books:
            if let item = self.itemsSorted[indexPath.section][indexPath.row] as? BookItem {
                cell.displayCell(rating: item.rating, title: item.title, detail: "完成时间： \(item.strDateAdded)", isSynced: item.updated)
            }
        case .movies:
            if let item = self.itemsSorted[indexPath.section][indexPath.row] as? MovieItem {
                cell.displayCell(rating: item.rating, title: item.title, detail: "观看时间： \(item.strDateAdded)", isSynced: item.updated)
            }
        case .unsigned:
            break
        }
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"
        {
            if let destinationVC = segue.destination as? ItemDetailTableViewController {
                if let cell = sender as? ItemTableViewCell{
                    let title = cell.titleLabel?.text
                    switch tableType {
                    case .books:
                        destinationVC.navigationItem.title = "书目详情"
                    case .movies:
                        destinationVC.navigationItem.title = "影片详情"
                    case .unsigned:
                        break
                    }
                    if let item = self.items.first(where: {$0.title == title}) {
                        destinationVC.chosenItem = item
                    }
                }
            }
        }
    }


}


