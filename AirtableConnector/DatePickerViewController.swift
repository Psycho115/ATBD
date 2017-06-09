//
//  DatePickerViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/5/30.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import CalendarView
import SwiftMoment

class DatePickerViewController: UIViewController, CalendarViewDelegate {
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var calendarView: CalendarView!
    
    var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendarView.delegate = self
        
        selectedDateLabel.clipsToBounds = true
        selectedDateLabel.cornerRadius = selectedDateLabel.frame.size.height/2
        selectedDateLabel.backgroundColor = UIColor.greyGreen
        selectedDateLabel.textColor = UIColor.white
    }
    
    func setSelectedDate(setDate: NSDate) {
        let date = moment(setDate as Date)
        self.calendarView.selectDate(date: date)
        self.selectedDateLabel.text = date.format("  MMMM d, yyyy  ")
    }
    
    func getSelectedDate() -> NSDate? {
        if self.selectedDate != nil {
            return NSDate(timeIntervalSince1970: (self.selectedDate?.timeIntervalSince1970)!)
        } else {
            return nil
        }
    }
    
    func calendarDidPageToDate(date: Moment) {
        //self.selectedDateLabel.text = date.format("MMMM d, yyyy")
    }
    
    func calendarDidSelectDate(date: Moment) {
        self.selectedDate = date.date
        self.selectedDateLabel.text = date.format(" MMMM d, yyyy  ")
    }

}
