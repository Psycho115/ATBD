//
//  SearchResultPageViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/5/29.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class SearchResultPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var vcs: [SearchResultViewController?] = [nil, nil]
    
    public var currentIndex: Int = 0 {
        didSet {
            self.segmentControl.selectedSegment = self.currentIndex
        }
    }
    public var lastPendingIndex: Int = 0
    
    weak var segmentControl: XMSegmentedControl!
    
    public var searchText: String? {
        didSet {
            for viewController in self.vcs {
                if let vc = viewController {
                    vc.searchText = searchText
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        vc1.tableType = .movies
        
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        vc2.tableType = .books
        
        self.vcs = [vc1, vc2]
        
        self.setViewControllers([self.ViewControllerAtIndex(index: 0)!], direction: .forward, animated: true, completion: nil)
    }

    public func displayViewController(index: Int) {
        
        if self.currentIndex == index {
            return
        } else if self.currentIndex < index {
            self.setViewControllers([self.ViewControllerAtIndex(index: index)!], direction: .forward, animated: true, completion: nil)
        } else {
            self.setViewControllers([self.ViewControllerAtIndex(index: index)!], direction: .reverse, animated: true, completion: nil)
        }
        
        self.currentIndex = index
    }
    
    //MARK: - Data Source
    
    private func ViewControllerAtIndex(index: Int) -> SearchResultViewController? {
        
        switch index {
            
        case 0:
            return vcs[0]
            
        case 1:
            return vcs[1]
            
        default:
            return nil
            
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! SearchResultViewController).index!
        print("now:\(index)")
        index -= 1
        return self.ViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! SearchResultViewController).index!
        print("now:\(index)")
        index += 1
        return self.ViewControllerAtIndex(index: index)
    }
    
    // MARK: - Delegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            self.currentIndex = self.lastPendingIndex
            print("now: \(self.currentIndex)")
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers[0] as? SearchResultViewController {
            self.lastPendingIndex = viewController.index!
            print("pending: \(self.lastPendingIndex)")
        }
    }
    
    

}
