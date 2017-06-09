//
//  DetailViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/3/11.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ExpandableLabelDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var chosenItem: NSFetchRequestResult?
    var image: UIImage?
    var colors: UIImageColors?
    
    @IBOutlet weak var topView: TopViewForDetail!
    @IBOutlet weak var coverImage: CoverImageView!
    
    func presetData(colors: UIImageColors, image: UIImage) {
        self.image = image
        self.colors = colors
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coverImage.setImage(image: self.image!)
        self.coverImage.shadowCastView()
        
        self.topView.chosenItem = self.chosenItem
        self.topView.presetData(colors: self.colors!)
        
        self.collectionView.backgroundColor = UIColor.eggshell
        self.view.backgroundColor = UIColor.eggshell
        
        let layout = ExpandableLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 320, height: 100)
        self.collectionView.collectionViewLayout = layout
    }
    
    // MARK: - Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20)
    }
    
    // MARK: UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextLabelCell", for: indexPath) as! TextLabelCell
        cell.detail.delegate = self
        if let item = self.chosenItem as? DBBookItem {
            cell.display(title: "内容介绍", detail: item.summary!)
        } else if let item = self.chosenItem as? DBMovieItem {
            cell.display(title: "内容介绍", detail: item.summary!)
        }
        
        return cell
    }
    
    // MARK: - expandable label
    
    func willExpandLabel(_ label: ExpandableLabel) {
        collectionView.reloadData()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        collectionView.reloadData()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
    }
    
    func shouldExpandLabel(_ label: ExpandableLabel) -> Bool {
        label.collapsed = false
        return true
    }
    
    func shouldCollapseLabel(_ label: ExpandableLabel) -> Bool {
        return true
    }
    

    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UnexpandSegue" {
//            if let destinationVC = segue.destination as? CardViewController {
//                print("sfgw")
//            }
//        }
    }

    
    func hideAll(bHide: Bool) {
        if bHide == true {
            self.collectionView.alpha = 0.0
            self.topView.stackedLabels.alpha = 0.0
        } else {
            self.collectionView.alpha = 1.0
            self.topView.stackedLabels.alpha = 1.0
        }
    }

}

class ExpandableLayout: UICollectionViewFlowLayout {
    
    override func awakeFromNib() {
        estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
    }

}

class TopViewForDetail: UIView {
    
    var chosenItem: NSFetchRequestResult? {
        didSet {
            guard self.chosenItem != nil else {
                return
            }
            if let item = chosenItem as? DBBookItem {
                self.stackedLabels.display(title: item.title, secondary: item.author, originTitle: item.originalTitle, date: item.dateAdded)
            } else if let item = chosenItem as? DBMovieItem {
                self.stackedLabels.display(title: item.title, secondary: item.director, originTitle: item.originalTitle, date: item.dateAdded)
            }
        }
    }
    
    var colorredBackgroundView: CurvedBackgroundView?
    @IBOutlet weak var stackedLabels: StackLabelView!
    
    override func awakeFromNib() {
        self.shadowCastView(offsetHeight: 5, radius: 5)
        
        let bgView = CurvedBackgroundView(frame: self.frame)
        
        self.insertSubview(bgView, belowSubview: self.stackedLabels)
        self.colorredBackgroundView = bgView
    }
    
    func presetData(colors: UIImageColors) {
        self.colorredBackgroundView?.backgroundColor = colors.backgroundColor.withAlphaComponent(0.8)
    }
    
    var color: UIColor = .eggshell
    
}
