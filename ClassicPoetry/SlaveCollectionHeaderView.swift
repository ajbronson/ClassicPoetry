//
//  SlaveCollectionHeaderView.swift
//  ClassicPoetry
//
//  Created by AJ Bronson on 1/8/17.
//  Copyright © 2017 AJ Bronson. All rights reserved.
//

import UIKit

class SlaveCollectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerTitle: UILabel!
    
    func updateHeader(title: String) {
        headerTitle.text = title
    }
}
