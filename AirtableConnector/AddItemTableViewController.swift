//
//  AddItemTableViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/26.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {
    
    var parentVC: ItemViewController?
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchIcon: UIView!
    
    private struct searchItem {
        var doubanID: String = ""
        var title: String = ""
        var person: String = ""
    }
    
    // datasource
    private let searchResultMaxCount = 5
    private var items = [searchItem]()
    
    @IBOutlet weak var searchField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableview
        self.tableView.tableFooterView = UIView()
        
        // searchField
        self.searchField.delegate = self
        self.searchField.tintColor = tableType.tintColor()
        
        // button
        self.dismissButton.tintColor = tableType.tintColor()
        
        // searchview
        self.searchIcon.tintColor = tableType.tintColor()
        self.searchView.shadowCastView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var keyboardHeight: CGFloat = 0
    
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchField.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool
    {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return self.searchView
    }
    
    // dismiss action
    
    @IBOutlet weak var dismissButton: UIButton!

    @IBAction func dismissSelf(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField.text == "" {
            self.items.removeAll()
            self.tableView.reloadData()
            return true
        }
        
        beginSearch {
            if self.items.count > 0 {
                self.tableView.reloadData()
                self.addHeaderView()
                self.tableView.scrollToRow(at: IndexPath(row: self.items.count-1, section: 0), at: .bottom, animated: false)
            }
        }
        return true
    }
    
    func addHeaderView() {
        self.tableView.tableHeaderView = nil
        let contentHeight = self.tableView.bounds.size.height - self.keyboardHeight - CGFloat(items.count*60) - UIApplication.shared.statusBarFrame.size.height
        if contentHeight > 0 {
            let frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: contentHeight)
            let headerView = UIView(frame: frame)
            self.tableView.tableHeaderView = headerView
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.items.removeAll()
        self.tableView.reloadData()
        return true
    }
    
    private func beginSearch(completion: (()->Void)? = nil) {
        self.items.removeAll()
        guard let searchInput = self.searchField.text else { return }
        let str = searchInput.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let searchString = "?q=" + str! + "&count=" + "\(searchResultMaxCount)"
        if let searchUrl = tableType.doubanSearchUrl() {
            Alamofire.request(searchUrl + searchString, method: .get)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let Json = JSON(value)
                        switch tableType {
                        case .books:
                            for (_, subJson): (String, JSON) in Json["books"] {
                                var item = searchItem()
                                item.title = subJson["title"].stringValue
                                item.doubanID = subJson["id"].stringValue
                                let personArray = subJson["author"].arrayValue.map({$0.stringValue})
                                item.person = personArray.joined(separator: ", ")
                                self.items.insert(item, at: 0)
                            }
                        case .movies:
                            for (_, subJson): (String, JSON) in Json["subjects"] {
                                var item = searchItem()
                                item.title = subJson["title"].stringValue
                                item.doubanID = subJson["id"].stringValue
                                item.person = subJson["original_title"].stringValue
                                self.items.insert(item, at: 0)
                            }
                        case .unsigned:
                            break
                        }
                        if let closure = completion {
                            closure()
                        }
                    case .failure( _):
                        print("Failed to connect to douban API")
                    }
            }
        }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchTableViewCell

        cell.parentVC = self
        cell.display(title: self.items[indexPath.row].title, detail: self.items[indexPath.row].person)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
