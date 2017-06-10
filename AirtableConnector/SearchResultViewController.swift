//
//  SearchResultViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/5/2.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import Jelly
import NVActivityIndicatorView
import ReachabilitySwift

private let reuseIdentifier = "SearchResultCollectionCell"

class SearchResultViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    var reachability = Reachability()!
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    var jellyAnimator: JellyAnimator?
    
    @IBOutlet weak var alertView: AlertView!
    
    private var previousSearch: String?
    public var searchText: String? {
        didSet {
            if self.searchText != nil && self.searchText != self.previousSearch {
                self.beginSearch()
                self.previousSearch = self.searchText
            }
        }
    }
    
    public var index: Int? {
        get {
            switch self.tableType {
            case .books:
                return 1
            case .movies:
                return 0
            default:
                return nil
            }
        }
    }
    
    public var tableType = TableType.movies
    
    private struct searchItem {
        var doubanID: String = ""
        var image: String = ""
        var title: String = ""
        var detail: String = ""
        var url: String = ""
    }
    
    // datasource
    private let searchResultMaxCount = 10
    private var items = [searchItem]() {
        didSet {
            if activityIndicatorView != nil {
                if activityIndicatorView.isAnimating {
                    activityIndicatorView.dispear(duration: 0.1, finished: {
                        self.activityIndicatorView.stopAnimating()
                    })
                    activityIndicatorView.stopAnimating()
                }
            }
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        self.clearsSelectionOnViewWillAppear = false
        
        activityIndicatorView = NVActivityIndicatorView(frame: self.view.frame)
        activityIndicatorView.type = .ballScaleRippleMultiple
        activityIndicatorView.color = UIColor.greyGreen
        activityIndicatorView.padding = CGFloat(160)
        self.collectionView?.backgroundView = activityIndicatorView
        
        alertView.frame = self.view.frame
        self.view.addSubview(alertView)
        
        alertView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    private func beginSearch(completion: (()->Void)? = nil) {
        self.items.removeAll()
        self.alertView.isHidden = true
        guard let text = self.searchText else { return }
        
        if !self.reachability.isReachable {
            self.alertView.display(alertType: .noConnection)
            self.alertView.isHidden = false
            return
        }
        
        activityIndicatorView.startAnimating()
        
        let str = text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let searchString = "?q=" + str! + "&count=" + "\(searchResultMaxCount)"
        if let searchUrl = tableType.doubanSearchUrl() {
            Alamofire.request(searchUrl + searchString, method: .get)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let Json = JSON(value)
                        switch self.tableType {
                        case .books:
                            for (_, subJson): (String, JSON) in Json["books"] {
                                var item = searchItem()
                                item.title = subJson["title"].stringValue
                                item.doubanID = subJson["id"].stringValue
                                let personArray = subJson["author"].arrayValue.map({$0.stringValue})
                                item.detail = personArray.joined(separator: ", ")
                                item.image = subJson["images"]["large"].stringValue
                                self.items.append(item)
                            }
                        case .movies:
                            for (_, subJson): (String, JSON) in Json["subjects"] {
                                var item = searchItem()
                                item.title = subJson["title"].stringValue
                                item.doubanID = subJson["id"].stringValue
                                item.detail = subJson["original_title"].stringValue
                                item.image = subJson["images"]["large"].stringValue
                                self.items.append(item)
                            }
                        case .unsigned:
                            break
                        }
                        if self.items.count==0 {
                            self.activityIndicatorView.dispear(duration: 0.1, finished: {
                                self.activityIndicatorView.stopAnimating()
                                self.alertView.display(alertType: .noResult)
                                self.alertView.isHidden = false
                            })
                        }
                        if let closure = completion {
                            closure()
                        }
                    case .failure( _):
                        self.activityIndicatorView.dispear(duration: 0.1, finished: {
                            self.activityIndicatorView.stopAnimating()
                            self.alertView.display(alertType: .failedAPI)
                            self.alertView.isHidden = false
                        })
                    }
            }
        }
        
    }
    
    public func InsertItem(id: String) {
        let coredataContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        switch self.tableType {
        case .books:
            _ = DBBookItem.InsertBookItem(id: id, inContext: coredataContext)
        case .movies:
            _ = DBMovieItem.InsertMovieItem(id: id, inContext: coredataContext)
        case .unsigned:
            break
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!ResultCollectionViewCell
        let item = items[indexPath.row]
        cell.parentVC = self
        cell.uniqueId = item.doubanID
        cell.initiate(image: item.image, title: item.title, detail: item.detail)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ResultCollectionViewCell
        
        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "AddItemDetailMenuViewController") as! AddItemDetailMenuViewController
        
        menuVC.parentVC = self
        menuVC.uniqueId = cell.uniqueId
        
        var presentation = JellySlideInPresentation()
        presentation.directionShow = .bottom
        presentation.directionDismiss = .bottom
        
        //size and postion
        let gap = 10
        let width = UIScreen.main.bounds.width - CGFloat(2*gap)
        presentation.widthForViewController = JellyConstants.Size.custom(value: width)
        presentation.heightForViewController = JellyConstants.Size.custom(value: 100)
        presentation.gapToScreenEdge = 2 * gap
        
        presentation.verticalAlignemt = .bottom
        presentation.backgroundStyle = .dimmed(alpha: 0.5)
        presentation.presentationCurve = .easeInEaseOut
        presentation.dismissComplete = nil
        self.jellyAnimator = JellyAnimator(presentation:presentation)
        self.jellyAnimator?.prepare(viewController: menuVC)
        self.present(menuVC, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row != self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row != self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
    }

}
