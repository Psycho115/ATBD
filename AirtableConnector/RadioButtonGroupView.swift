//
//  RadioButtonGroupView.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/21.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import QuartzCore

class RadioButtonGroupView: UIStackView {
    
    @IBOutlet var radioButtonGroupList: Array<UIButton>!
    
    @IBAction func radioTouched(sender: AnyObject) {
        
        guard let radio = sender as? UIButton else {return}
        
        //guard radio.isSelected != true else {
            //radio.isSelected = false
        //    return
        //}
        
        if let radioSelect = radioButtonGroupList.filter({$0.tag == radio.tag}).first {
            radioSelect.isSelected = true
        }
        
        for radioDeselect in radioButtonGroupList.filter({$0.tag != radio.tag}) {
            radioDeselect.isSelected = false
        }
        
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setRadioTag()
    }
    
    internal func setRadioTag() {
        for radioButton in radioButtonGroupList {
            radioButton.tag = ((radioButtonGroupList.index(of: radioButton) ?? 0) + 1) * 10000
        }
    }
    
    public func deselectAllRadios() {
        for radioButton in radioButtonGroupList {
            radioButton.isSelected = false
        }
    }
    
    public func setRadioButtonSelected(buttonTitle: String) {
        for button in radioButtonGroupList {
            if let title = button.titleLabel?.text {
                if title == buttonTitle {
                    button.isSelected = true
                    break
                }
            }
        }
    }
    
    public func getRadioButtonSelected() -> String? {
        var buttonTitle: String?
        for button in radioButtonGroupList {
            if button.isSelected {
                buttonTitle = button.titleLabel?.text
                break
            }
        }
        return buttonTitle
    }

}

class RadioButtonGroup: UIView {
    
    private var radioButtonGroupList: Array<UIButton> = []
    
    func radioTouched(sender: UITapGestureRecognizer) {
        
        guard let radio = sender.view as? UIButton else {return}
        
        if let radioSelect = radioButtonGroupList.filter({$0.tag == radio.tag}).first {
            radioSelect.isSelected = true
            print("\(radioSelect.tag)")
        }
        
        for radioDeselect in radioButtonGroupList.filter({$0.tag != radio.tag}) {
            radioDeselect.isSelected = false
        }
        
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        //setRadioTag()
    }
    
    internal func setRadioTag() {
        for radioButton in radioButtonGroupList {
            radioButton.tag = ((radioButtonGroupList.index(of: radioButton) ?? 0) + 1) * 10000
        }
    }
    
    public func addButton(button: UIButton) {
        radioButtonGroupList.append(button)
        button.tag = ((radioButtonGroupList.index(of: button) ?? 0) + 1) * 10000
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(radioTouched(sender:)))
        button.addGestureRecognizer(tap)
    }
    
    public func deselectAllRadios() {
        for radioButton in radioButtonGroupList {
            radioButton.isSelected = false
        }
    }
    
    public func setRadioButtonSelected(buttonTitle: String) {
        for button in radioButtonGroupList {
            if let title = button.titleLabel?.text {
                if title == buttonTitle {
                    button.isSelected = true
                    break
                }
            }
        }
    }
    
    public func getRadioButtonSelected() -> String? {
        var buttonTitle: String?
        for button in radioButtonGroupList {
            if button.isSelected {
                buttonTitle = button.titleLabel?.text
                break
            }
        }
        return buttonTitle
    }
    
}

class ZFRippleButton: UIButton {
    
    var backgroundView = UIView()
    
    override func awakeFromNib() {
        titleLabel?.sizeToFit()
        tintColor = UIColor.clear
        setTitleColor(UIColor.black, for: .selected)
        setup()
    }
    
    fileprivate func setup() {
        setupBackgoundView()
        backgroundView.alpha = 0.5
        addSubview(backgroundView)
        
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
    }
    
    fileprivate func setupBackgoundView() {
        let x: CGFloat = (bounds.width/2) - ((titleLabel?.bounds.width)!/2)
        let y: CGFloat = (bounds.height/2) + ((titleLabel?.bounds.height)!/2)
        let corner: CGFloat = 1
        
        backgroundView.backgroundColor = UIColor.lightRed
        backgroundView.frame = CGRect(x: x, y: y, width: (titleLabel?.bounds.width)!, height: 3)
        backgroundView.layer.cornerRadius = corner
    }
    
    override func draw(_ rect: CGRect) {
        backgroundView.isHidden = !isSelected
    }
}
