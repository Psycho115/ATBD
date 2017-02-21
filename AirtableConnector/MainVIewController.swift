//
//  ViewController.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/27.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var bookIcon: UIImageView!
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var bookView: UIView!
    @IBOutlet weak var filmView: UIView!
    @IBOutlet var titleView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bookViewTap = UITapGestureRecognizer(target: self, action: #selector(self.bookViewTapped))
        self.bookView.addGestureRecognizer(bookViewTap)
        let filmViewTap = UITapGestureRecognizer(target: self, action: #selector(self.filmViewTapped))
        self.filmView.addGestureRecognizer(filmViewTap)
        
        self.bookIcon.tintColor = UIColor.eggshell
        self.filmImage.tintColor = UIColor.eggshell
        
        self.bookView.backgroundColor = UIColor.lightBlue
        self.filmView.backgroundColor = UIColor.lightRed
        
        self.navigationItem.titleView = self.titleView

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.eggshell
    }
    
    func bookViewTapped() {
        performSegue(withIdentifier: "ShowItems", sender: "BOOKS")
    }
    
    func filmViewTapped() {
        performSegue(withIdentifier: "ShowItems", sender: "MOVIES")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItems"
        {
            if let destinationVC = segue.destination as? ItemViewController {
                if let viewName = sender as? String {
                    destinationVC.navigationItem.title = viewName
                    switch viewName {
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

