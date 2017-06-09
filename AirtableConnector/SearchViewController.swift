//
//  SearchViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/5/2.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, XMSegmentedControlDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var segmentControl: XMSegmentedControl!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var resultContainer: UIView!
    weak var resultVC: SearchResultPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.resultContainer.addSubview(self.resultVC!.view)
        
        //search view
        searchButton.tintColor = UIColor.black
        searchBar.tintColor = UIColor.greyGreen
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        
        searchView.backgroundColor = UIColor.white
        searchView.shadowCastView()

        //Segment control
        segmentControl.delegate = self
        segmentControl.segmentTitle = ["Movies","Books"]
        segmentControl.selectedItemHighlightStyle = .bottomEdge
        segmentControl.backgroundColor = UIColor.white
        segmentControl.highlightColor = UIColor.greyGreen
        segmentControl.tint = UIColor.black
        segmentControl.highlightTint = UIColor.black
        
        //top view
        self.bottomLine.backgroundColor = UIColor.greyGreen

    }
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        self.resultVC?.displayViewController(index: selectedSegment)
    }
    
    
    // MARD: - Searchbar
    
    override var inputAccessoryView: UIView? {
        return self.searchView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.resignFirstResponder()
        self.resultVC?.searchText = self.searchBar.text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.resignFirstResponder()
        self.resultVC?.searchText = nil
    }
    
    @IBAction func openSearch(_ button: UIButton) {
        if self.searchBar.isFirstResponder {
            self.searchBar.resignFirstResponder()
            self.resignFirstResponder()
        } else {
            self.becomeFirstResponder()
            self.searchBar.becomeFirstResponder()
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearchResult" {
            if let destinationVC = segue.destination as? SearchResultPageViewController{
                self.resultVC = destinationVC
                self.resultVC?.segmentControl = self.segmentControl
                self.resultVC?.view.frame = resultContainer.bounds
            }
        }
    }

}
