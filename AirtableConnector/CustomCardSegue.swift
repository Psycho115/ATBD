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
        
        destinationVC.view.alpha = 0.0
        destinationVC.view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        
        UIApplication.shared.keyWindow?.addSubview(destinationVC.view)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            destinationVC.view.transform = CGAffineTransform.identity
            destinationVC.view.alpha = 1.0
        }) { finished in
            sourceVC.present(destinationVC, animated: false, completion: nil)
        }
        
    }

}

class CardSlideSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let sourceVC = self.source 
        
        let destinationVC = self.destination
        
        destinationVC.view.alpha = 0.0
        destinationVC.view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        
        UIApplication.shared.keyWindow?.addSubview(destinationVC.view)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            destinationVC.view.transform = CGAffineTransform.identity
            destinationVC.view.alpha = 1.0
        }) { finished in
            sourceVC.present(destinationVC, animated: false, completion: nil)
        }
        
    }
    
}

class ExpandSegue: UIStoryboardSegue {
    
    override func perform() {
        
//        let sourceVC = self.source as! CardViewController
//        let destinationVC = self.destination as! DetailViewController
//
//        destinationVC.view.alpha = 0.0
//        //let coverCenter = sourceVC.coverContainer.center
//        let cardCenter = sourceVC.cardContainer.center
//
//        UIApplication.shared.keyWindow?.insertSubview(destinationVC.view, aboveSubview: sourceVC.view)
//        
//        var toCenter = sourceVC.view.superview?.convert(destinationVC.coverImage.center, from: destinationVC.view.superview)
//        toCenter?.y += 20
//        
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
//            sourceVC.coverContainer.center = toCenter!
//            sourceVC.coverContainer.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//            sourceVC.cardContainer.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
//        }) { finished in
//            destinationVC.view.alpha = 1.0
//            destinationVC.topView.center.y -= destinationVC.topView.frame.size.height + 20
//            destinationVC.collectionView.center.y  += destinationVC.collectionView.frame.size.height
//            UIView.animate(withDuration: 0.4, animations: {
//                destinationVC.topView.center.y += destinationVC.topView.frame.size.height + 20
//                destinationVC.collectionView.center.y -= destinationVC.collectionView.frame.size.height
//            }, completion: { (_) in
//                destinationVC.view.removeFromSuperview()
//                sourceVC.present(destinationVC, animated: false, completion: nil)
////                sourceVC.coverContainer.center = coverCenter
////                sourceVC.cardContainer.center = cardCenter
////                sourceVC.coverContainer.transform = CGAffineTransform.identity
////                sourceVC.cardContainer.transform = CGAffineTransform.identity
//            })
//        }
    }
    
}

class UnexpandSegue: UIStoryboardSegue {
    
    override func perform() {
        
//        print("segue")
//
//        
//        let sourceVC = self.source as! DetailViewController
//        let destinationVC = self.destination as! CardViewController
//        
//        let window = UIApplication.shared.keyWindow
//        
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
//            sourceVC.topView.center.y -= sourceVC.topView.frame.size.height + 50
//            sourceVC.collectionView.center.y += sourceVC.collectionView.frame.size.height
//        }) { finished in
//            sourceVC.topView.isHidden = true
//            sourceVC.collectionView.isHidden = true
////            window?.insertSubview(destinationVC.view, belowSubview: sourceVC.view)
//            
////            sourceVC.dismiss(animated: false, completion: nil)
//            destinationVC.collapse(function: {
//                sourceVC.dismiss(animated: false, completion: nil)
//            })
//
////            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
////                sourceVC.view.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
////            }) { (finished) in
//////                destinationVC.view.removeFromSuperview()
////                sourceVC.dismiss(animated: false, completion: nil)
////            }
//        }
        
        
    }
    
}
