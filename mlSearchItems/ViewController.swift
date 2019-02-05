//
//  ViewController.swift
//  mlSearchItems
//
//  Created by Guille on 2/1/19.
//  Copyright © 2019 Guille. All rights reserved.
//

import UIKit
import Crashlytics

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.errorLabel.isHidden = true
        if (Singleton.sharedInstance.errorMsg != "")
        {
            self.errorLabel.text = Singleton.sharedInstance.errorMsg
            Singleton.sharedInstance.errorMsg = ""
            self.errorLabel.isHidden = false
        }
    }

    //MARK: Actions
    @IBAction func searchAction(_ sender: Any) {
        if searchText.text == "" {return}
        Crashlytics.sharedInstance().setObjectValue(searchText.text, forKey: "search_UI")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        Singleton.self.sharedInstance.searchStr = searchText.text!
        let tableViewController = storyBoard.instantiateViewController(withIdentifier: "resultTableView") as! resultTableViewController

        let navController = storyBoard.instantiateViewController(withIdentifier: "navigationTable") as! UINavigationController
        navController.pushViewController(tableViewController, animated: true)
        self.present(navController, animated: true, completion: nil)
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  
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
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        Crashlytics.sharedInstance().setObjectValue(link, forKey: "downloadImage")
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
