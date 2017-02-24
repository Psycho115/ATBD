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
    @IBOutlet weak var sortRatioButtonsView: RadioButtonGroupView!
    @IBOutlet weak var sectionRatioButtonsView: RadioButtonGroupView!
    
    func dismissComplete() {
        let sortSelection = sortRatioButtonsView.getRadioButtonSelected()
        tmpSortSetting.matchSort(str: sortSelection!)
        let sectionSelection = sectionRatioButtonsView.getRadioButtonSelected()
        tmpSortSetting.matchSection(str: sectionSelection!)
        sortSetting = self.tmpSortSetting
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            
        sortRatioButtonsView.setRadioButtonSelected(buttonTitle: tmpSortSetting.sortType.typeStr())
        sectionRatioButtonsView.setRadioButtonSelected(buttonTitle: tmpSortSetting.sectionType.typeStr())
    }

}
