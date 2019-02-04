//
//  resultTableViewController.swift
//  mlSearchItems
//
//  Created by Guille on 2/2/19.
//  Copyright © 2019 Guille. All rights reserved.
//

import UIKit

class resultTableViewController: UITableViewController {
    var searchStr: String = ""
    var gtitles: [String] = []
    var images: [String] = []
    var price: [String] = []
    var qty: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gtitles.count
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ItemTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
        
        cell.titleCell.text = self.gtitles[indexPath.row]
        cell.imageCell.downloaded(from: self.images[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        print("title: " + self.gtitles[indexPath.row])
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemViewController = storyBoard.instantiateViewController(withIdentifier: "itemViewController") as! ItemViewController
        itemViewController.titleStr = self.gtitles[indexPath.row]
        itemViewController.priceStr = self.price[indexPath.row]
        
        let navController = storyBoard.instantiateViewController(withIdentifier: "itemNavController") as! UINavigationController
        navController.pushViewController(itemViewController, animated: true)
        self.present(navController, animated: true, completion: nil)
    }
    
    deinit {
        print("Remove NotificationCenter Deinit")
        NotificationCenter.default.removeObserver(self)
    }
}
