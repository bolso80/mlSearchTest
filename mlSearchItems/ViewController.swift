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
        let url = URL(string: "https://api.mercadolibre.com/sites/MLU/search?q=" + searchText.text!)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            do{
                //here data received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: []) as? [String: Any]
                
                guard let jsonArray = jsonResponse?["results"] as? [[String: Any]] else {
                    return
                }
                
                for case let item in jsonArray {
                    guard let results = item["title"] as? String else { return }; print(results) // delectus aut autem
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        task.resume()
    }
    
}

