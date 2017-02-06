//
//  ViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/27.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItems"
        {
            if let destinationVC = segue.destination as? ItemViewController {
                if let button = sender as? UIButton {
                    destinationVC.navigationItem.title = button.titleLabel?.text
                    if let tableString = button.titleLabel?.text {
                        switch tableString {
                        case "BOOKS":
                            tableType = .books
                        case "MOVIES":
                            tableType = .movies
                        default:
                            tableType = .unsigned
                        }
                    }
                }
            }
        }
    }
    
    
    
}

