//
//  Volume.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import Foundation
import GRDB

class Volume {
    
    //MARK: - Properties
    
    let id: Int
    let name: String
    
    //MARK: - Initializers
    
    init(row: Row) {
        id = row.value(named: "id")
        name = row.value(named: "name")
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
