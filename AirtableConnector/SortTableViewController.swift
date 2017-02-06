//
//  SortTableViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/3.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class SortTableViewController: UITableViewController {
    
    var sectionSwtichIsOn = sortSetting.sectionType != .noSection
    
    func switchSet(sender: UISwitch) {
        self.sectionSwtichIsOn = sender.isOn
        if !sender.isOn {
            sortSetting.sectionType = .noSection
        }
        self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(self.getBack)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    private var tableList: [Array<String>] {
        get {
            if self.sectionSwtichIsOn {
                return [[SortType.byTimeAdded.typeStr(), SortType.byRating.typeStr(), SortType.byTitle.typeStr()],
                        ["分组开启"],
                        [SectionType.byTitleFirstLetter.typeStr(), SectionType.byYear.typeStr(), SectionType.byMonth.typeStr()]]
            }
            else {
                return [[SortType.byTimeAdded.typeStr(), SortType.byRating.typeStr(), SortType.byTitle.typeStr()],
                        ["分组关闭"],
                        []]
            }
        }
    }
    private var sectionTitle: [String] {
        get {
            if self.sectionSwtichIsOn {
                return ["选择排序依据", "分组", "选择分组依据"]
            }
            else {
                return ["选择排序依据", "分组", ""]
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sectionTitle.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tableList[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitle[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            let sectionSwitch = UISwitch(frame: CGRect())
            sectionSwitch.onTintColor = UIColor.lightBlue
            sectionSwitch.setOn(self.sectionSwtichIsOn, animated: true)
            sectionSwitch.addTarget(self, action: #selector(self.switchSet), for: UIControlEvents.valueChanged)
            cell.textLabel?.text = self.tableList[indexPath.section][indexPath.row]
            cell.accessoryView = sectionSwitch
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as? CheckTableViewCell
            if indexPath.section == 0 {
                cell?.display(title: self.tableList[indexPath.section][indexPath.row], cellType: .sort)
            } else {
                cell?.display(title: self.tableList[indexPath.section][indexPath.row], cellType: .section)
            }
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = Array(0..<self.tableList[indexPath.section].count).map({ row in return IndexPath(row: row, section: indexPath.section)})
        self.tableView.reloadRows(at: path, with: .none)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
