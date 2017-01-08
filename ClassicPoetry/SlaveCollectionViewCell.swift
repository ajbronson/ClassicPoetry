//
//  SlaveCollectionViewCell.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var customView: UIView!
    var faceUp = true
    
    func updateWith(book: Book, showHints: Bool) {
        if faceUp {
            titleLabel.text = book.reference
            subtitleLabel.text = showHints ? book.hint : ""
            customView.layer.cornerRadius = 5
        } else {
            titleLabel.text = book.text
        }
    }
}
