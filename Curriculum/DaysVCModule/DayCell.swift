//
//  DayCollectionCell.swift
//  Curriculum
//
//  Created by VironIT Developer on 12/6/17.
//  Copyright © 2017 VironIT Developer. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lightImageView: UIImageView!

    var day: String? {
        didSet {
            dayLabel.text  = day
        }
    }

    var cellBackgroundColor: UIColor? {
        didSet {
            view.backgroundColor = cellBackgroundColor
        }
    }

    var buttonImage: UIImage? {
        didSet {
            lightImageView.image = buttonImage
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
