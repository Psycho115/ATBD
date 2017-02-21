//
//  CardPopupSegue.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/7.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class CardPopupSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let sourceVC = self.source
        
        let destinationVC = self.destination
        
        (destinationVC as? CardViewController)?.blurView.alpha = 0.0
        
        destinationVC.view.alpha = 0.0
        destinationVC.view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        
        UIApplication.shared.keyWindow?.addSubview(destinationVC.view)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            destinationVC.view.transform = CGAffineTransform.identity
            destinationVC.view.alpha = 1.0
            (destinationVC as? CardViewController)?.blurView.alpha = 1.0
        }) { finished in
            sourceVC.present(destinationVC, animated: false, completion: nil)
        }
        
    }

}

class CardSlideSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let sourceVC = self.source
        
        
        
        sourceVC.view.alpha = 1.0
        
        UIApplication.shared.keyWindow?.addSubview(sourceVC.view)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            sourceVC.view.alpha = 0.0
        }) { finished in
            sourceVC.dismiss(animated: false, completion: nil)
        }
        
    }
    
}
