//
//  Singleton.swift
//  mlSearchItems
//
//  Created by Guille on 2/4/19.
//  Copyright © 2019 Guille. All rights reserved.
//

import Foundation

final class Singleton {
    
    // Can't init is singleton
    private init() { }
    
    //MARK: Shared Instance
    
    static let sharedInstance: Singleton = Singleton()
    
    //MARK: Local Variable
    
    var searchStr : String = ""
    
}
