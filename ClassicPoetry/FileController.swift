//
//  FileController.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import Foundation
import GRDB

class FileController {
    
    //MARK: - Constants
    
    struct Constant {
        static let fileName = "poemDB_v2.0"
        static let fileExtension = "sql"
        static let fontSize = "fontSize"
    }
    
    //MARK: - Singleton
    
    static let shared = FileController()
    
    //MARK: - Properties
    
    var dbQueue: DatabaseQueue!
    
    
    fileprivate init() {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            dbQueue = try? DatabaseQueue(path: "\(documentDirectory.absoluteString)\(FileController.Constant.fileName).\(FileController.Constant.fileExtension)")
        }
    }
    
    
    func volumes() -> [Volume] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Volume] in
            var volumes: [Volume] = []
            volumes.append(Volume(id: 0, name: "All Poems"))
            for row in try Row.fetchAll(db, "select * from canon") {
                volumes.append(Volume(row: row))
            }
            return volumes
        })
    }
    
    func volumeNameForID(id: Int) -> String {
        return try! dbQueue.inDatabase({ (db: Database) -> String in
            var name: String = ""
            if id == 0 {
                return "All Poems"
            }
            for row in try Row.fetchAll(db, "select * from canon where id = \(id)") {
                name = row.value(named: "name")
            }
            return name
        })
    }
    
    func book(volumeID: Int) -> [Book] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Book] in
            var books: [Book] = []
            if volumeID == 0 {
                for row in try Row.fetchAll(db, "select * from poems order by id") {
                    books.append(Book(row: row))
                }
            } else {
                for row in try Row.fetchAll(db, "select * from poems where canon_id = \(volumeID) order by id") {
                    books.append(Book(row: row))
                }
            }

            return books
        })
    }
    
    func greenStars() -> [Book] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Book] in
            var books: [Book] = []
            
            for row in try Row.fetchAll(db, "select * from poems where has_green_star = 1") {
                books.append(Book(row: row))
            }
            return books
        })
    }
    
    func yellowStars() -> [Book] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Book] in
            var books: [Book] = []
            
            for row in try Row.fetchAll(db, "select * from poems where has_yellow_star = 1") {
                books.append(Book(row: row))
            }
            return books
        })
    }
    
    func blueStars() -> [Book] {
        return try! dbQueue.inDatabase({ (db: Database) -> [Book] in
            var books: [Book] = []
            
            for row in try Row.fetchAll(db, "select * from poems where has_blue_star = 1") {
                books.append(Book(row: row))
            }
            return books
        })
    }
    
    func updateBookStar() {
        
    }
    
    func updateBookStar(book: Book, hasYellowStar: Int, hasBlueStar: Int, hasGreenStar: Int) {
        dbQueue.inDatabase { (db: Database) -> Void in
            let me = try? db.makeUpdateStatement("UPDATE poems SET has_yellow_star = \(hasYellowStar), has_blue_star = \(hasBlueStar), has_green_star = \(hasGreenStar) WHERE id = \(book.id)")
            try? me?.execute()
        }
    }
    
    func updateStarWithBookID(id: Int, hasYellowStar: Int, hasBlueStar: Int, hasGreenStar: Int) {
        dbQueue.inDatabase { (db: Database) -> Void in
            let me = try? db.makeUpdateStatement("UPDATE poems SET has_yellow_star = \(hasYellowStar), has_blue_star = \(hasBlueStar), has_green_star = \(hasGreenStar) WHERE id = \(id)")
            try? me?.execute()
        }
    }
    
    func getFirstLetterOfStringWithMultipleStrings(stringToUse: String, addNumberOfBreaks: Int) -> String {
        var stringToReturn = ""
        if var first = stringToUse.characters.first {
            while first == "(" || first == "\"" || first == "'" {
                let removeIndex = stringToUse.index(stringToUse.startIndex, offsetBy: 0)
                var modifiedString = stringToUse
                modifiedString.remove(at: removeIndex)
                if let newFirst = modifiedString.characters.first {
                    first = newFirst
                }
            }
            
            stringToReturn += "\(String(describing: first))"
            stringToReturn += containsPunction(word: stringToUse)
            for _ in 0..<addNumberOfBreaks {
                stringToReturn += "<br> "
            }
        }
        return stringToReturn
    }
    
    func containsPunction(word: String) -> String {
        if let character = word.characters.last {
            if character == "," || character == "." || character == ":" || character == ";" || character == "!" || character == "?" {
                return "\(String(character)) "
            }
        }
        return " "

    }
    
    func removeEmptyElementsFromArray(array: [String]) -> [String] {
        var array = array
        var indexToRemove: [Int] = []
        for i in 0..<array.count {
            if array[i] == "" {
                indexToRemove.append(i)
            }
        }
        for i in 0..<indexToRemove.count {
            array.remove(at: (indexToRemove[i] - i))
        }
        return array
    }
}
