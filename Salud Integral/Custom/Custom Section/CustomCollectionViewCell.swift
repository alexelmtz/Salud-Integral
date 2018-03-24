//
//  CollectionViewCell.swift
//  Salud Integral
//
//  Created by Alex Elizondo  on 3/2/18.
//  Copyright © 2018 Alex Elizondo . All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
