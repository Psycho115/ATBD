//
//  ItemTableViewCell.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/1.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import Jelly
import CoreData

class ItemTableViewCell: SwipeTableViewCell {
    
    public var item: DBItemBase?

    @IBOutlet weak var syncIcon: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingIcon: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var coverImage: CoverImageView!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var ratingStars: StackedStarsView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet var tags: [UILabel]!
    
    var unique: String?
    
    var rating: Float {
        get {
            return Float(ratingLabel.text!)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.syncIcon.tintColor = tableType.tintColor()
        
        self.moreButton.cornerRadius = self.moreButton.frame.size.height*0.5
        
        for tag in self.tags {
            tag.clipsToBounds = true
            tag.cornerRadius = tag.frame.size.height/2
            tag.backgroundColor = UIColor.greyGreen
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.setBackgroundColorForRatingLabel()
    }
    
    func initCell(source: DBItemBase?, indexPath: IndexPath) {
        
        self.item = source
        //self.moreButton.tag
        
        if let item = source as? DBBookItem {
            displayCell(rating: item.rating, title: item.title, detail: item.dateAdded?.formatForDate, isSynced: true, unique: item.unique, image: item.images?.medium, oriTitle: item.originalTitle, myRating: item.myRating)
        }
        if let item = source as? DBMovieItem {
            displayCell(rating: item.rating, title: item.title, detail: item.dateAdded?.formatForDate, isSynced: true, unique: item.unique, image: item.images?.medium, oriTitle: item.originalTitle, myRating: item.myRating)

        }
    }
    
    func displayCell(rating: Float?, title: String?, detail: String?, isSynced: Bool, unique: String?, image: String?, oriTitle: String?, myRating: Float?) {
        self.titleLabel.text = title ?? ""
        self.detailLabel.text = detail ?? ""
        self.ratingLabel.text = String(rating ?? 0.0)
        self.coverImage.displayImage(url: image!)
        self.syncIcon.image = isSynced ? #imageLiteral(resourceName: "ic_cloud_done_white") : #imageLiteral(resourceName: "ic_cloud_queue_white")
        self.syncIcon.tintColor = isSynced ? UIColor.lightGreen : tableType.tintColor()
        self.originalTitleLabel.text = oriTitle ?? ""
        self.ratingStars.display(rating: myRating ?? 0.0)
        
        self.unique = unique
    }
    
//    func updateRatings() {
//        self.item.rate
//    }
    
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
        let red = CIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        let yellow = CIColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 1.0)
        let green = CIColor(red: 0.2, green: 0.85, blue: 0.2, alpha: 1.0)
        var color: UIColor
        
        let colorRatio = (rating - 6.0) / (9.0 - 6.0)
        color = ColorInBetween(clr1: red, clr2: yellow, clr3: green, ratio: Float(colorRatio)).colorInBetween
        self.ratingIcon.layer.backgroundColor = color.cgColor
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

class HeaderView: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var line: UIView!
    
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var line3: UIView!
    
    override func awakeFromNib() {
    }
    
    func display(title: String?, count: String?) {
        self.line.backgroundColor = UIColor.greyGreen
        self.line2.backgroundColor = UIColor.greyGreen
        self.line3.backgroundColor = UIColor.greyGreen
        self.label.text = title
        if count != nil {
            self.countLabel.text = count
        } else {
            self.countLabel.text = nil
            self.line2.isHidden = true
        }
    }
    
}

class FooterView: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var line2: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.setImage(#imageLiteral(resourceName: "ic_arrow_drop_up_36pt"), for: .normal)
    }
}

class StackedStarsView: UIStackView {
    
    @IBOutlet var stars: Array<UIImageView>!
    
    func display(rating: Float) {
        
        for star in stars {
            star.image = #imageLiteral(resourceName: "ic_star_border")
        }
        
        for star in stars {
            star.tintColor = UIColor.orange
        }
        
        let starCount = Int(rating)
        
        for idx in 0..<starCount {
            self.stars[idx].isHidden = false
            self.stars[idx].image = #imageLiteral(resourceName: "ic_star_white")
        }
        
        if rating - Float(starCount) >= 0.5 {
            self.stars[starCount].isHidden = false
            self.stars[starCount].image = #imageLiteral(resourceName: "ic_star_half_white")
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
