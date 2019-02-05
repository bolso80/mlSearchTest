//
//  resultTableViewController.swift
//  mlSearchItems
//
//  Created by Guille on 2/2/19.
//  Copyright © 2019 Guille. All rights reserved.
//

import UIKit
import Crashlytics

class resultTableViewController: UITableViewController {
    var searchStr: String = ""
    var gtitles: [String] = []
    var images: [String] = []
    var price: [String] = []
    var ids: [String] = []
    var qty: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addBackButton()
        chargeTable()
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "BackButton.png"), for: .normal)
        backButton.setTitle("  Back", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "initView")
        
        self.present(viewController, animated: true, completion: nil)
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
        Crashlytics.sharedInstance().setObjectValue(self.gtitles[indexPath.row], forKey: "selectItem")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemViewController = storyBoard.instantiateViewController(withIdentifier: "itemViewController") as! ItemViewController
        itemViewController.titleStr = self.gtitles[indexPath.row]
        itemViewController.priceStr = self.price[indexPath.row]
        itemViewController.imageStr = self.images[indexPath.row]
        
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
                    Singleton.sharedInstance.errorMsg = "VERIFIQUE SU CONEXION"
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
                        guard let id = item["id"] as? String else {
                            self.makeError(code: 1, desc: "parseId")
                            continue };
                        guard let title = item["title"] as? String else {
                            self.makeError(code: 2, desc: "parseTitleId:" + id)
                            continue };
                        guard let thumbnail = item["thumbnail"] as? String else {
                            self.makeError(code: 3, desc: "parseThumbnailId:" + id)
                            continue };
                        guard let cur = item["currency_id"] as? String else {
                            self.makeError(code: 4, desc: "parseCurrencyId:" + id)
                            continue };
                        guard let price = item["price"] as? Int else {
                            self.makeError(code: 5, desc: "parsePriceId:" + id)
                            continue };
                        
                        
                        self.gtitles.append(title)
                        self.images.append(thumbnail)
                        self.price.append(cur + " " + String(price))
                        self.ids.append(id)
                        
                        
                        index = index + 1
                        print(title) // delectus aut autem
                    }
                    group.leave()
                    
                } catch let parsingError {
                    Crashlytics.sharedInstance().recordError(parsingError)
                    Singleton.sharedInstance.errorMsg = "INTENTE SU BUSQUEDA NUEVAMENTE"
                    group.leave()
                }
            }
            
            task.resume()
        }
        
        group.wait()
        if Singleton.sharedInstance.errorMsg != ""
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "initView")
            
            self.present(viewController, animated: true, completion: nil)
        }
        self.tableView.reloadData()
    }
    
    func makeError(code: Int, desc: String)
    {
        let errorTemp = NSError(domain:"chargeTable" + desc, code:code, userInfo:nil)
        Crashlytics.sharedInstance().recordError(errorTemp)
    }
}
