//
//  HorizontalCollectionViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/6/2.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionCardCell"

class HorizontalCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.collectionView?.delegate = self
        
        self.collectionView?.allowsMultipleSelection = false
        
        let innerColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        let outerColor = UIColor(white: 1.0, alpha: 1.0).cgColor;
        
        
        let colors = [outerColor, innerColor,innerColor,outerColor]
        let locations = [0.0, 0.03, 0.97, 1.0]
        
        let vMaskLayer : CAGradientLayer = CAGradientLayer()
        vMaskLayer.opacity = 0.5
        vMaskLayer.colors = colors
        vMaskLayer.locations = locations as [NSNumber]
        vMaskLayer.bounds = self.view.bounds
        vMaskLayer.bounds.size.width = 357
        vMaskLayer.startPoint = CGPoint(x: 0, y: 0.5)
        vMaskLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        vMaskLayer.anchorPoint = CGPoint.zero
        
        // you must add the mask to the root view, not the scrollView, otherwise
        // the masks will move as the user scrolls!
        self.view.layer.addSublayer(vMaskLayer)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedRow = getSelectedRow() {
            collectionView?.scrollToItem(at: IndexPath(row: selectedRow, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

    public func getSelectedRow() -> Int? {
        if let dataSource = collectionView?.dataSource as? SingleSelectionDataSource {
            return dataSource.selectedRow
        } else {
            return nil
        }
    }
    
    public func setSelectedRow(row: Int?) {
        if var dataSource = collectionView?.dataSource as? SingleSelectionDataSource {
            dataSource.selectedRow = row
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch collectionView.indexPathsForSelectedItems?.first {
//        case .some(indexPath):
//            return CGSize(width: 100, height: 60) // your selected height
//        default:
        return CGSize(width: 120, height: 60)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCardCell {
            cell.setSelected(isSelected: true)
        }
        if var dataSource = collectionView.dataSource as? SingleSelectionDataSource {
            let oldSelected = dataSource.selectedRow
            dataSource.selectedRow = indexPath.row
            if (oldSelected != nil) {
                collectionView.reloadItems(at: [IndexPath(row: oldSelected!, section: 0)])
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCardCell {
            cell.setSelected(isSelected: false)
        }
    }

}

class CollectionCardCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    var maskLayer = UIView(frame: CGRect.zero)
    
    var currentY: CGFloat?
    
    override func awakeFromNib() {
        button.tintColor = UIColor.black
        self.backgroundColor = UIColor.clear
        button.cornerRadius = 3
        button.backgroundColor = UIColor.white
        self.shadowCastView(offsetHeight: 0, radius: 5, color: UIColor.black, shadowOpacity: 0.1)
        
        //shadowLayer.translatesAutoresizingMaskIntoConstraints = false
        maskLayer.frame = button.frame
        maskLayer.bounds = button.bounds
        maskLayer.center = button.center
        maskLayer.backgroundColor = UIColor.greyGreen
        maskLayer.alpha = 0.7
        button.addSubview(maskLayer)
    }
    
    func displayCell(title: String, image: UIImage? = nil, tag: Int) {
        button.setTitle(title, for: .normal)
        //button.setBackgroundImage(image, for: .normal)
        self.tag = tag
    }
    
    func setSelected(isSelected: Bool) {
        if isSelected == true {
            maskLayer.isHidden = false
            self.shadowCastView(offsetHeight: 0, radius: 4, color: UIColor.black, shadowOpacity: 0.2)
        } else {
            maskLayer.isHidden = true
            self.shadowCastView(offsetHeight: 0, radius: 8, color: UIColor.black, shadowOpacity: 0.2)
        }
    }
    
    
}
