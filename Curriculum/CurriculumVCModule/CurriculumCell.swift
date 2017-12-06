//
//  CurriculumCell.swift
//  Curriculum
//
//  Created by VironIT Developer on 12/6/17.
//  Copyright © 2017 VironIT Developer. All rights reserved.
//

import UIKit

class CurriculumCell: UITableViewCell {

    @IBOutlet weak var eventTextView: UITextView!

    var delegate: CurriculumCellDelegate!

    var eventTitle: String? {
        didSet {
            eventTextView.text = eventTitle
        }
    }

    var changedEventTitle: String? {
        return eventTextView.text
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eventTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CurriculumCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate.reloadTableView(cell: self)
    }
    
}
