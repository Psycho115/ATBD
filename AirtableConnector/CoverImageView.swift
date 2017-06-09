//
//  CoverImageView.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/6.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit
import Alamofire

class CoverImageView: UIView {
    
    private var shouldSetupConstraints = true

    var backgroundView: UIActivityIndicatorView?
    var imageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView = UIImageView()
        self.addSubview(imageView!)
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.center = self.center
        self.backgroundView = spinner
        self.backgroundView?.startAnimating()
        self.imageView?.addSubview(self.backgroundView!)
        
        self.backgroundColor = UIColor.white
        
        //constraints
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        imageView?.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        self.shadowCastView(offsetHeight: 0, radius: 5, color: UIColor.black, shadowOpacity: 0.1)
        imageView?.cornerRadius = 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: CGRect.zero)
        self.addSubview(imageView!)
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.center = self.center
        self.backgroundView = spinner
        self.backgroundView?.startAnimating()
        self.imageView?.addSubview(self.backgroundView!)
        
        //self.backgroundColor = UIColor.eggshell
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setImage(image: UIImage) {
        self.imageView?.image = image
    }
    
    func getImage() -> UIImage? {
        return imageView?.image
    }
    
    func displayImage(url: String, completion: ((UIImageColors?)->Void)? = nil) {
//        self.backgroundView?.startAnimating()

        Alamofire.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    if (self.backgroundView?.isAnimating)! {
                        self.backgroundView?.stopAnimating()
                    }
                    self.imageView?.image = image
                    if let closure = completion {
                        self.imageView?.image?.getColors(scaleDownSize: CGSize.zero, completionHandler: { (colors) in
                            closure(colors)
                        })
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func displayImageAndGetColors(url: String, completion: ((UIImageColors?)->Void)? = nil) {
        Alamofire.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    if (self.backgroundView?.isAnimating)! {
                        self.backgroundView?.stopAnimating()
                    }
                    self.imageView?.image = image
                    if let closure = completion {
                        self.imageView?.image?.getColors(scaleDownSize: CGSize.zero, completionHandler: { (colors) in
                            closure(colors)
                        })
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
