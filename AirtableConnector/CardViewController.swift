//
//  CardViewController.swift
//  
//
//  Created by 唐敬哲 on 2017/2/6.
//
//

import UIKit
import CoreData

class CardViewController: UIViewController {

    @IBOutlet weak var cardContainer: UIView!
    var cardViewController: DetailCardViewController?
    
    @IBOutlet weak var coverContainer: UIView!
    var coverViewController: ImageViewController?

    @IBAction func SwipeDismiss(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    var isExpanded = false
    let expandingOffset: CGFloat = 50
    
    func expandDetailCard() {
        
        if self.isExpanded == false {
            self.cardContainer.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            self.cardContainer.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.cardContainer.transform = CGAffineTransform.identity
                self.cardContainer.center.y += self.expandingOffset/2.0
                self.coverContainer.center.y -= self.expandingOffset
            }, completion: { (_) in
                self.isExpanded = true
            })
        } else {
            self.cardContainer.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.3, animations: {
                self.cardContainer.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
                self.cardContainer.center.y -= self.expandingOffset/2.0
                self.coverContainer.center.y += self.expandingOffset
            }, completion: { (_) in
                self.cardContainer.isHidden = true
                self.isExpanded = false
            })
        }
    }
    
    // MARK: - navigation index for page view controller
    
    var index = 0
    
    var chosenItem: NSFetchRequestResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardContainer.addSubview(self.cardViewController!.view)
        self.coverContainer.addSubview(self.coverViewController!.view)
        
        self.coverContainer.shadowCastView()
        self.cardContainer.isHidden = true
        print("card generated!")
    }
    
    deinit {
        print("card destroyed!")
    }

    // MARK: - Navigation
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        
        print("_")
    }
    
    func collapse(function: @escaping ()->Void) {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
            //self.coverContainer.center = toImageCenter
            self.coverContainer.transform = CGAffineTransform.identity
            self.cardContainer.transform = CGAffineTransform.identity
        }) { finished in
            function()
        }
    }
    
    func ShowDetailViewController() {
        guard self.coverViewController?.image.getImage() != nil && self.cardViewController?.colors != nil else { return }
        
//        //let toImageCenter = self.view.convert(destinationVC.coverImage.center, from: destinationVC.view)
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
//            //self.coverContainer.center = toImageCenter
//            self.coverContainer.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//            self.cardContainer.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
//        }) { finished in }
        performSegue(withIdentifier: "ShowDetailViewController", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailCard" {
            if let destinationVC = segue.destination as? DetailCardViewController {
                self.cardViewController = destinationVC
                self.cardViewController?.view.frame = self.cardContainer.bounds
                self.cardViewController?.chosenItem = self.chosenItem
            }
        }
        if segue.identifier == "ShowCoverImage" {
            if let destinationVC = segue.destination as? ImageViewController {
                self.coverViewController = destinationVC
                self.coverViewController?.parentVC = self
                self.coverViewController?.view.frame = self.coverContainer.bounds
                if let item = self.chosenItem as? DBBookItem {
                    self.coverViewController?.imageUrl = item.images?.large
                }
                if let item = self.chosenItem as? DBMovieItem {
                    self.coverViewController?.imageUrl = item.images?.large
                }
            }
        }
        if segue.identifier == "ShowDetailViewController" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.chosenItem = self.chosenItem
                destinationVC.presetData(colors: (self.cardViewController?.colors)!, image: (self.coverViewController?.image.getImage())!)
            }
        }
    }

}
