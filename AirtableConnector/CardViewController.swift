//
//  CardViewController.swift
//  
//
//  Created by 唐敬哲 on 2017/2/6.
//
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var cardContainer: UIView!
    var cardTableViewController: DetailCardViewController?

    @IBAction func SwipeDismiss(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        //let segue = CardSlideSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        //segue.perform()
    }
    
    //navigation index for page view controller
    var index = 0
    
    var chosenItem = ItemBase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardContainer.addSubview(self.cardTableViewController!.view)
        print("\(self.chosenItem.title) card generated!")
    }
    
    deinit {
        print("\(self.chosenItem.title) card destroyed!")
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailCard"
        {
            if let destinationVC = segue.destination as? DetailCardViewController {
                self.cardTableViewController = destinationVC
                self.cardTableViewController?.view.frame = self.cardContainer.bounds
                self.cardTableViewController?.chosenItem = self.chosenItem
            }
        }
    }

}
