//
//  SortMenuViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/8.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class SortMenuViewController: UIViewController {
    
    weak var parentVC: ItemTableViewController?
    
    @IBOutlet weak var sortContainer: UIView!
    weak var sortVC: HorizontalCollectionViewController?
    private var sortDataSource = SortDataSource()
    
    @IBOutlet weak var sectionContainer: UIView!
    weak var sectionVC: HorizontalCollectionViewController?
    private var sectionDataSource = SectionDataSource()
    
    //model
    var tmpSortSetting = sortSetting
    
    func dismissComplete() {
        if let sortSelection = sortVC?.getSelectedRow() {
            tmpSortSetting.matchSort(int: sortSelection)
        }
        if let sectionSelection = sectionVC?.getSelectedRow() {
            tmpSortSetting.matchSection(int: sectionSelection)
        }
        sortSetting = self.tmpSortSetting
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sortContainer.addSubview(self.sortVC!.view)
        sortVC?.collectionView?.dataSource = self.sortDataSource
        
        self.sectionContainer.addSubview(self.sectionVC!.view)
        sectionVC?.collectionView?.dataSource = self.sectionDataSource
        
        sortVC?.setSelectedRow(row: sortSetting.sortType.convertToInt())
        sectionVC?.setSelectedRow(row: sortSetting.sectionType.convertToInt())
        
    }
    
    // MARK: UICollectionViewDataSource
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbbedSort" {
            if let destinationVC = segue.destination as? HorizontalCollectionViewController{
                self.sortVC = destinationVC
                self.sortVC?.view.frame = self.sortContainer.bounds
            }
        }
        if segue.identifier == "EmbbedSection" {
            if let destinationVC = segue.destination as? HorizontalCollectionViewController{
                self.sectionVC = destinationVC
                self.sectionVC?.view.frame = self.sectionContainer.bounds
            }
        }
    }

}

class SortDataSource: NSObject, UICollectionViewDataSource, SingleSelectionDataSource {
    
    var selectedRow: Int?
    
    let sortNames = SortType.names()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCardCell", for: indexPath) as! CollectionCardCell
        
        cell.displayCell(title: sortNames[indexPath.row], image: nil, tag: indexPath.row)
        
        if selectedRow != nil {
            cell.setSelected(isSelected: selectedRow! == indexPath.row)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortNames.count
    }
    
}

class SectionDataSource: NSObject, UICollectionViewDataSource, SingleSelectionDataSource {
    
    var selectedRow: Int?
    
    let sectionNames = SectionType.names()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCardCell", for: indexPath) as! CollectionCardCell
        
        cell.displayCell(title: sectionNames[indexPath.row], image: nil, tag: indexPath.row)
        
        if selectedRow != nil {
            cell.setSelected(isSelected: selectedRow! == indexPath.row)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionNames.count
    }
    
}

protocol SingleSelectionDataSource {
    var selectedRow: Int? { get set }
}
