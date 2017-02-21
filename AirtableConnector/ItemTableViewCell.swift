//
//  ItemTableViewCell.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/1.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var syncIcon: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var rating: Double {
        get {
            return Double(ratingLabel.text!)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.syncIcon.tintColor = tableType.tintColor()
    }
    
    override func draw(_ rect: CGRect) {
        self.setBackgroundColorForRatingLabel()
    }
    
    func displayCell(rating: Double, title: String, detail: String, isSynced: Bool) {
        self.titleLabel.text = title
        self.detailLabel.text = detail
        self.ratingLabel.text = String(rating)
        self.syncIcon.isHidden = isSynced
    }
    
    func startSyncronizing() {
        let image = #imageLiteral(resourceName: "ic_cloud_upload_white").withRenderingMode(.alwaysTemplate)
        self.syncIcon.changeImage(duration: 0.4, changeToImage: image)
    }
    
    func stopSyncronizing() {
        let image = #imageLiteral(resourceName: "ic_cloud_done_white").withRenderingMode(.alwaysTemplate)
        self.syncIcon.changeTintColor(duration: 1.0, color: UIColor(red: 0.2, green: 0.85, blue: 0.2, alpha: 1.0), finished: {
            self.syncIcon.changeImage(duration: 1.0, changeToImage: image)
        })
    }
    
    private func setBackgroundColorForRatingLabel() {
        let red = CIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        let yellow = CIColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 1.0)
        let green = CIColor(red: 0.2, green: 0.85, blue: 0.2, alpha: 1.0)
        var color: UIColor
        
        let colorRatio = (rating - 6.0) / (9.0 - 6.0)
        color = ColorInBetween(clr1: red, clr2: yellow, clr3: green, ratio: Float(colorRatio)).colorInBetween
        self.ratingLabel.layer.backgroundColor = color.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.setBackgroundColorForRatingLabel()
        setHighlighted(false, animated: true)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        // Configure the view for the selected state
        self.setBackgroundColorForRatingLabel()
        if highlighted {
            self.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1.0)
        } else {
            self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }

}

struct ColorInBetween {
    
    let clr1: CIColor
    let clr2: CIColor
    var ratio: Float
    
    var colorInBetween: UIColor {
        get {
            let rgb = [(clr1.red, clr2.red), (clr1.green, clr2.green), (clr1.blue, clr2.blue)].map {
                getValueInBetween(v1: $0, v2: $1)
            }
            return UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1.0)
        }
    }
    
    init(clr1: CIColor, clr2: CIColor, clr3: CIColor, ratio: Float) {
        if ratio >= 0.5 {
            self.ratio = 2.0 * (ratio - 0.5)
            self.clr1 = clr2
            self.clr2 = clr3
        } else {
            self.ratio = 2.0 * ratio
            self.clr1 = clr1
            self.clr2 = clr2
        }
    }
    
    private func getValueInBetween(v1: CGFloat, v2: CGFloat) -> CGFloat {
        if v1 == v2 { return v1 }
        else {
            var r = self.ratio
            if self.ratio > 1.0 { r = 1.0 }
            if self.ratio < 0.0 { r = 0.0 }
            return (v2 - v1) * CGFloat(r) + v1
        }
    }
    
}
