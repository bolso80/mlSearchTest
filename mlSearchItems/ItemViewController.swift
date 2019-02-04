//
//  ItemViewController.swift
//  mlSearchItems
//
//  Created by Guille on 2/1/19.
//  Copyright © 2019 Guille. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    //MARK: Properties
    
    var searchStr: String = ""
    var titleStr: String = ""
    var imageStr: String = ""
    var priceStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    func back(sender: UIBarButtonItem) {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tableViewController = storyBoard.instantiateViewController(withIdentifier: "resultTableView") as! resultTableViewController
        
        let navController = storyBoard.instantiateViewController(withIdentifier: "navigationTable") as! UINavigationController
        navController.pushViewController(tableViewController, animated: true)
        self.present(navController, animated: true, completion: nil)
    }
    
}

