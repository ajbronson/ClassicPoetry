//
//  StringHelper.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import Foundation

extension String {
    func getStringArray() -> [String] {
        return self.components(separatedBy: " ")
    }
    
    func setFirstLetters() -> String {
        var stringToReturn = ""
        
        for string in self.getStringArray() {
            if var first = string.characters.first {
                while first == "(" || first == "\"" {
                    let removeIndex = string.index(string.startIndex, offsetBy: 0)
                    var modifiedString = string
                    modifiedString.remove(at: removeIndex)
                    if let newFirst = modifiedString.characters.first {
                        first = newFirst
                    }
                }
                stringToReturn += "\(String(describing: first)) "
            }
        }
        
        return stringToReturn
    }
    
    func getSections() -> [String] {
        let set = CharacterSet(charactersIn: ",.:;!?-\n")
        var stringArray = self.components(separatedBy: set)
        var positionsToRemove: [Int] = []
        
        for i in 0..<stringArray.count {
            let currentString = stringArray[i]
            if currentString == "" || currentString == " " {
                positionsToRemove.append(i)
            }
        }
        
        for i in 0..<positionsToRemove.count {
            let position = positionsToRemove[i]
            stringArray.remove(at: position - i)
        }
        
        for i in 0..<stringArray.count {
            var currentString = stringArray[i]
            if i != stringArray.count - 1 {
                let nextString = stringArray[i + 1]
                if let last = currentString.characters.last,
                    let first = nextString.characters.first {
                    if last != " " && first != " " {
                        stringArray[i] += " "
                    }
                }
            }
        }
        
        return stringArray
    }
}
