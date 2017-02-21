//
//  SlaveCollectionViewCell.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/7/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var customView: UIView!
    
    //MARK: - Helper Methods
    
    func updateWith(book: Book, showHints: Bool) {
        titleLabel.text = book.reference
        subtitleLabel.text = showHints ? book.hint : ""
        customView.layer.cornerRadius = 5
        let textSize = UserDefaults.standard.integer(forKey: FileController.Constant.fontSize)
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize)/6.2)
        subtitleLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize)/10)
    }
}
