//
//  LargeSlaveCollectionViewCell.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import UIKit

class LargeSlaveCollectionViewCell: UIViewController, UIWebViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var largeWebView: UIWebView!
    @IBOutlet weak var largeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Properties
    
    var book: Book?
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        largeView.layer.cornerRadius = 5
        
        if let book = book {
            let bookText = book.text.replacingOccurrences(of: "\n", with: "<br/>")
            largeWebView.loadHTMLString(bookText, baseURL: nil)
            titleLabel.text = book.reference
        }
        
        self.view.backgroundColor = UIColor(colorLiteralRed: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 0.7)
    }
    
    //MARK: - WebView Delegate Method
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textSize = UserDefaults.standard.integer(forKey: FileController.Constant.fontSize)
        largeWebView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'")
    }
    
    //MARK: - Helper Methods
    
    func updateWith(book: Book) {
        self.book = book
    }
    
    //MARK: - Actions
    
    @IBAction func userTappedScreen(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

