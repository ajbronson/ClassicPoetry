//
//  Book.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import Foundation
import GRDB

class Book: Equatable {
    
    //MARK: - Properties
    
    let id: Int
    let reference: String
    let text: String
    let hint: String
    let canonID: Int
    var blueStar: Bool?
    var greenStar: Bool?
    var yellowStar: Bool?
    var memorized: Bool?
    
    //MARK: - Initializer
    
    init(row: Row) {
        id = row.value(named: "id")
        reference = row.value(named: "title")
        text = row.value(named: "text")
        hint = row.value(named: "year")
        canonID = row.value(named: "canon_id")
        blueStar = row.value(named: "has_blue_star")
        greenStar = row.value(named: "has_green_star")
        yellowStar = row.value(named: "has_yellow_star")
        memorized = row.value(named: "memorized")
    }
}

//Equatable Method

func ==(rhs: Book, lhs: Book) -> Bool {
    return rhs.id == lhs.id
}
