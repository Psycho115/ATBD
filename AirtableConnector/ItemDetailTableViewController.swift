//
//  ItemDetailTableViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/29.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import Alamofire

class ItemDetailTableViewController: UITableViewController {
    
    //model data
    var chosenItem = ItemBase()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.chosenItem.itemDetailTitle.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return self.chosenItem.itemDetailTitle[section]
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let height = UIScreen.main.bounds.height / 3.0
            return height
        } else {
            return 45.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1.0
        } else {
            return 20.0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let detail = self.chosenItem.getItemDetailArray()!
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemImageCell", for: indexPath) as! ImageTableViewCell

            Alamofire.request(detail[indexPath.section]).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        cell.displayImage(image: image)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailCell", for: indexPath) as!ScrollTableViewCell
            cell.textLabel?.text = detail[indexPath.section]
            return cell
        }

    }

 
}
