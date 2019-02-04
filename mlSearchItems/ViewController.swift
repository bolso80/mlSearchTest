//
//  ViewController.swift
//  mlSearchItems
//
//  Created by Guille on 2/1/19.
//  Copyright © 2019 Guille. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: Actions
    @IBAction func searchAction(_ sender: Any) {

        let original = "https://api.mercadolibre.com/sites/MLU/search?q=" + searchText.text!
        if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded)
        {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                
                do{
                    //here data received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: []) as? [String: Any]
                    
                    guard let jsonArray = jsonResponse?["results"] as? [[String: Any]] else {
                        return
                    }
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tableViewController = storyBoard.instantiateViewController(withIdentifier: "resultTableView") as! resultTableViewController
                    var index = 0
                    tableViewController.qty = jsonArray.count
                    for case let item in jsonArray {
                        guard let title = item["title"] as? String else { return };
                        guard let thumbnail = item["thumbnail"] as? String else { return };
                        guard let cur = item["currency_id"] as? String else { return };
                        guard let price = item["price"] as? Int else { return };
                        
                        
                        tableViewController.gtitles.append(title)
                        tableViewController.images.append(thumbnail)
                        tableViewController.price.append(cur + " " + String(price))
                        
                        
                        index = index + 1
                        print(title) // delectus aut autem
                    }
                    tableViewController.tableView.reloadData()
                    DispatchQueue.main.async {
                        let navController = storyBoard.instantiateViewController(withIdentifier: "navigationTable") as! UINavigationController
                        navController.pushViewController(tableViewController, animated: true)
                        self.present(navController, animated: true, completion: nil)
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            
            task.resume()
        }
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
