//
//  ResultCollectionViewCell.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/5/3.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    weak var parentVC: SearchResultViewController?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var coverImage: CoverImageView!
    
    var uniqueId = ""
    
    public func initiate(image: String?, title: String?, detail: String?) {
        self.coverImage.displayImage(url: image!)
        self.titleLabel.text = title
        self.detailLabel.text = detail ?? " "
    }
    
    public func display(isHighlighted: Bool) {
    }
    
    public func selected(isSelected: Bool) {
        if isSelected {
        } else {
        }
    }
    
    @IBAction func cellAddItem(_ sender: UIButton) {
        self.parentVC?.InsertItem(id: self.uniqueId)
    }

}

class ConfirmationView: UIView {
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.greyGreen.withAlphaComponent(0.8)
        self.yesButton.tintColor = UIColor.white
        self.noButton.tintColor = UIColor.white
        self.moreButton.tintColor = UIColor.white
    }

}

class AlertView: UIView {
    
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    
    enum AlertType {
        case noResult
        case noConnection
        case failedAPI
    }
    
    func display(alertType: AlertType) {
        switch alertType {
        case .noResult:
            self.alertImage.image = #imageLiteral(resourceName: "ic_book")
            self.alertLabel.text = "无相关结果"
        case .noConnection:
            self.alertImage.image = #imageLiteral(resourceName: "ic_book")
            self.alertLabel.text = "请检查网络连接"
        case .failedAPI:
            self.alertImage.image = #imageLiteral(resourceName: "ic_book")
            self.alertLabel.text = "超出访问限制，请稍后再试"
        }
    }
    
    
    
}
