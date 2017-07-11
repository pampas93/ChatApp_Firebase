//
//  Group.swift
//  ChatApp_Firebase
//
//  Created by Abhijit on 7/11/17.
//  Copyright © 2017 Abhijit. All rights reserved.
//

import Foundation

class  Group{
    
    let id: String
    let name: String
    let lma : Date
    
    init(id: String, name: String, lma: Date) {
        self.id = id
        self.name = name
        self.lma = lma
    }
}
