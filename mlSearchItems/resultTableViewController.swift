//
//  resultTableViewController.swift
//  mlSearchItems
//
//  Created by Guille on 2/2/19.
//  Copyright © 2019 Guille. All rights reserved.
//

import UIKit

class resultTableViewController: UITableViewController {
    var titles: [String] = []
    var images: [String] = []
    var qty: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ItemTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
        
        cell.titleCell.setTitle(self.titles[indexPath.row], for: .normal)
        let url = URL(string: self.images[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        print("title: " + self.titles[indexPath.row])
    }
}
