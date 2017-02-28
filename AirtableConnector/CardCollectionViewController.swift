//
//  ViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/27.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CardCollectionCell"

class CardCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet var titleView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.titleView = self.titleView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.eggshell
    }
    
    // MARK: UICollectionViewDataSource
    
    private let cardItems: [(UIImage, String, UIColor)] = [
        (#imageLiteral(resourceName: "ic_collections_bookmark_white_48pt"), "BOOKS", UIColor.lightBlue),
        (#imageLiteral(resourceName: "ic_video_library_white_48pt"), "MOVIES", UIColor.lightRed),
        (#imageLiteral(resourceName: "ic_library_add_white_48pt"), "NEW", UIColor.lightGreen)
    ]
    
    // MARK: UICollectionViewDelegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!CardCollectionCell
        let item = cardItems[indexPath.row]
        cell.initiate(image: item.0, title: item.1, themeColor: item.2)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionCell
        //cell.display(isHighlighted: false)
        let title = cell.cardLabel.text!
        performSegue(withIdentifier: "ShowItems", sender: title)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionCell
        cell.display(isHighlighted: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionCell
        cell.display(isHighlighted: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row != self.cardItems.count - 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row != self.cardItems.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    // MARK: - navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItems"
        {
            if let destinationVC = segue.destination as? ItemViewController {
                if let viewName = sender as? String {
                    destinationVC.navigationItem.title = viewName
                    switch viewName {
                    case "BOOKS":
                        tableType = .books
                    case "MOVIES":
                        tableType = .movies
                    default:
                        tableType = .unsigned
                    }
                }
            }
        }
    }

    
    
    
}

