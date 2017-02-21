//
//  SortMenuViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/8.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class SortMenuViewController: UIViewController {
    
    var parentVC: ItemViewController?
    
    //model
    var tmpSortSetting = sortSetting
    
    //outlets
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneDismiss(_ sender: UIButton) {
        sortSetting = self.tmpSortSetting
        self.dismiss(animated: true) { self.parentVC?.sortSettingDone() }
    }
    
    //pickers data source
    let sortTitles = [SortType.byTimeAdded.typeStr(), SortType.byRating.typeStr(), SortType.byTitle.typeStr()]
    let sectionTitles = ["不", SectionType.byTitleFirstLetter.typeStr(), SectionType.byMonth.typeStr(), SectionType.byYear.typeStr()]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton.tintColor = tableType.tintColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //picker data source & delegate
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 { return self.sectionTitles.count }
//        else { return self.sortTitles.count }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 28
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        
//        var label: UILabel
//        if let view = view as? UILabel { label = view }
//        else { label = UILabel() }
//        
//        label.textColor = .black
//        label.textAlignment = .center
//        label.font = UIFont(name: "SanFranciscoText-Light", size: 17)
//        
//        if component == 0 { label.text = self.sectionTitles[row] + "分组" }
//        else { label.text = self.sortTitles[row] + "排序" }
//        
//        return label
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if component == 0 {
//            self.tmpSortSetting.matchSection(index: row)
//        }
//        else {
//            self.tmpSortSetting.matchSort(index: row)
//        }
//    }
    
    
    // MARK: - Navigation

}
