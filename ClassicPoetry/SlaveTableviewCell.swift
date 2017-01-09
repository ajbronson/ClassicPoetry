//
//  SlaveTableviewCell.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    var delegate: ChangeStar?
    var book: Book?
    var isInStarMode = false
    
    func updateWith(book: Book, isInStarMode: Bool) {
        titleLabel.text = book.reference
        subtitleLabel.text = book.hint
        self.book = book
        self.isInStarMode = isInStarMode
        
        if let blue = book.blueStar, blue {
            starButton.setImage(UIImage(named: "BlueStar"), for: .normal)
        } else if let green = book.greenStar, green {
            starButton.setImage(UIImage(named: "GreenStar"), for: .normal)
        } else if let yellow = book.yellowStar, yellow {
            starButton.setImage(UIImage(named: "YellowStar"), for: .normal)
        } else {
            starButton.setImage(UIImage(named: "WhiteStar"), for: .normal)
        }
        
        let textSize = UserDefaults.standard.integer(forKey: FileController.Constant.fontSize)
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize)/6.2)
        subtitleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize)/10)
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        if let book = book {
            if isInStarMode {
                FileController.shared.updateBookStar(book: book, hasYellowStar: 0, hasBlueStar: 0, hasGreenStar: 0)
                book.blueStar = false
                book.greenStar = false
                book.yellowStar = false
            } else {
                if let green = book.greenStar, green {
                    FileController.shared.updateBookStar(book: book, hasYellowStar: 0, hasBlueStar: 1, hasGreenStar: 0)
                    book.blueStar = true
                    book.greenStar = false
                } else if let blue = book.blueStar, blue {
                    FileController.shared.updateBookStar(book: book, hasYellowStar: 1, hasBlueStar: 0, hasGreenStar: 0)
                    book.yellowStar = true
                    book.blueStar = false
                } else if let yellow = book.yellowStar, yellow {
                    FileController.shared.updateBookStar(book: book, hasYellowStar: 0, hasBlueStar: 0, hasGreenStar: 0)
                    book.yellowStar = false
                } else {
                    FileController.shared.updateBookStar(book: book, hasYellowStar: 0, hasBlueStar: 0, hasGreenStar: 1)
                    book.greenStar = true
                }
            }
        }
        delegate?.shouldChangeStar(sender: self, starMode: isInStarMode)
    }
}
