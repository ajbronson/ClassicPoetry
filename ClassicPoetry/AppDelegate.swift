//
//  AppDelegate.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Set Font Size
        
        if UserDefaults.standard.value(forKey: FileController.Constant.fontSize) == nil {
            UserDefaults.standard.set(110, forKey: FileController.Constant.fontSize)
        }
        
        //Move Database To Documents
        
        let fileManager = FileManager.default
        let documentsURL = try! FileManager().url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true)
        let databasePath = documentsURL.appendingPathComponent("\(FileController.Constant.fileName).\(FileController.Constant.fileExtension)")
        
        if !FileManager().fileExists(atPath: databasePath.path) {
            let location = Bundle.main.path(forResource: FileController.Constant.fileName, ofType: FileController.Constant.fileExtension)!
            let newURL = documentsURL.appendingPathComponent(FileController.Constant.fileName).appendingPathExtension(FileController.Constant.fileExtension)
            
            if let databaseURL = URL(string: "file://\(location)") {
                do {
                    try fileManager.copyItem(at: databaseURL, to: newURL)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        }
        
        //Convert old stars to new database
        
//        if let memorizedArray = UserDefaults.standard.array(forKey: "memorizedArray") {
//            for i in 0..<memorizedArray.count {
//                if let item = memorizedArray[i] as? String {
//                    if item == "1" {
//                        //GOLD_STAR
//                        FileController.shared.updateStarWithBookID(id: i, hasYellowStar: 1, hasBlueStar: 0, hasGreenStar: 0)
//                    } else if item == "2" {
//                        //BLUE_STAR
//                        FileController.shared.updateStarWithBookID(id: i, hasYellowStar: 0, hasBlueStar: 1, hasGreenStar: 0)
//                    } else if item == "3" {
//                        //GREEN_STAR
//                        FileController.shared.updateStarWithBookID(id: i, hasYellowStar: 0, hasBlueStar: 0, hasGreenStar: 1)
//                    }
//                }
//            }
//            
//            UserDefaults.standard.removeObject(forKey: "memorizedArray")
//            UserDefaults.standard.synchronize()
//        }
        
        var count = UserDefaults.standard.integer(forKey: "launchCount")
        count = count + 1
        UserDefaults.standard.set(count, forKey: "launchCount")
        
        Flurry.startSession("5PMPH29TW3N2MG8KFSZJ")
        Flurry.logEvent("Application Launch!")
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            Flurry.logEvent("Application Launch! Unique ID: \(id)")
        } else {
            Flurry.logEvent("Application Launch! Unique ID: Unknown")
        }
        
        return true
    }
}

