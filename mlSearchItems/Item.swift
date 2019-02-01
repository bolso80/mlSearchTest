//
//  Item.swift
//  mlSearchItems
//
//  Created by Guille on 2/1/19.
//  Copyright © 2019 Guille. All rights reserved.
//

import UIKit

class Item {
    
    //MARK: Properties
    
    var title: String
    var photo: UIImage?
    
    //MARK: Initialization
    
    init?(title: String, photo: UIImage?) {
        if title.isEmpty  {
            return nil
        }
        
        self.title = title
        self.photo = photo
    }
    
}
