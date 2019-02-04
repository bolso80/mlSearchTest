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
        chargeTable()
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
        itemViewController.searchStr = self.searchStr
        
        let navController = storyBoard.instantiateViewController(withIdentifier: "itemNavController") as! UINavigationController
        navController.pushViewController(itemViewController, animated: true)
        self.present(navController, animated: true, completion: nil)
    }
    
    func chargeTable()
    {
        let group = DispatchGroup()
        group.enter()
        
        let original = "https://api.mercadolibre.com/sites/MLU/search?q=" + Singleton.self.sharedInstance.searchStr
        if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded)
        {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else {
                    group.leave()
                    return
                    
                }
                
                do{
                    //here data received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: []) as? [String: Any]
                    
                    guard let jsonArray = jsonResponse?["results"] as? [[String: Any]] else {
                        group.leave()
                        return
                    }
                    
                    var index = 0
                    self.qty = jsonArray.count
                    for case let item in jsonArray {
                        guard let title = item["title"] as? String else { continue };
                        guard let thumbnail = item["thumbnail"] as? String else { continue };
                        guard let cur = item["currency_id"] as? String else { continue };
                        guard let price = item["price"] as? Int else { continue };
                        
                        
                        self.gtitles.append(title)
                        self.images.append(thumbnail)
                        self.price.append(cur + " " + String(price))
                        
                        
                        index = index + 1
                        print(title) // delectus aut autem
                    }
                    group.leave()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                    group.leave()
                }
            }
            
            task.resume()
        }
        
        group.wait()
        self.tableView.reloadData()
    }
}
