//
//  SectionViewController.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var sectionWebView: UIWebView!
    @IBOutlet weak var displayingLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var sections: [String] = []
    var displayingSections = 1
    var firstLetterOnly = false
    var book: Book?
    var books: [Book]?
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeButton.layer.cornerRadius = 5
        addButton.layer.cornerRadius = 5
        if let parentVC = parent as? TextTabBar,
            let book = parentVC.book,
            let books = parentVC.books {
            self.books = books
            self.book = book
            self.tabBarController?.title = book.reference
            sections = book.text.getSections()
            reloadHTML()
            updateDisplaying()
        }
    }
    
    //MARK: - Helper Methods
    
    func reloadHTML() {
        var stringToShow = ""
        for i in 0..<displayingSections {
            if firstLetterOnly && i != displayingSections - 1 {
                stringToShow += "\(sections[i].setFirstLetters()) | "
            } else {
                stringToShow += "\(sections[i]) | "
            }
        }
        let bookText = stringToShow.replacingOccurrences(of: "\n", with: "<br/>")
        sectionWebView.loadHTMLString(bookText, baseURL: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: FileController.Constant.fontSize)
        sectionWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
        
        if let heightResult = sectionWebView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;"),
            let height = Int(heightResult) {
            let script = "scrollTo(1, \(height))"
            sectionWebView.stringByEvaluatingJavaScript(from: script)
        }
    }
    
    func updateDisplaying() {
        displayingLabel.text = "Displaying Sections \(displayingSections) of \(sections.count)"
    }
    
    func bookDidChange() {
        if let book = book {
            self.tabBarController?.title = book.reference
            sections = book.text.getSections()
            displayingSections = 1
            reloadHTML()
            updateDisplaying()
        }
    }
    
    //MARK: - Actions
    
    @IBAction func removeSectionButtonTapped(_ sender: UIButton) {
        if displayingSections > 0 {
            displayingSections -= 1
            reloadHTML()
            updateDisplaying()
        }
    }
    
    @IBAction func addSectionButtonTapped(_ sender: UIButton) {
        if displayingSections < sections.count {
            displayingSections += 1
            reloadHTML()
            updateDisplaying()
        }
    }
    
    @IBAction func firstLetterToggled(_ sender: UISwitch) {
        firstLetterOnly = sender.isOn
        reloadHTML()
    }
    
    @IBAction func screenSwipedRight(_ sender: UISwipeGestureRecognizer) {
        if let parentVC = parent as? TextTabBar {
            if parentVC.switchToBook(next: false) {
                bookDidChange()
            }
        }
    }
    
    @IBAction func screenSwipedLeft(_ sender: UISwipeGestureRecognizer) {
        if let parentVC = parent as? TextTabBar {
            if parentVC.switchToBook(next: true) {
                bookDidChange()
            }
        }
    }
    
}