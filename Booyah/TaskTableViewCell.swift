//
//  TaskTableViewCell.swift
//  Booyah
//
//  Created by Paul Zhang on 6/10/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskAddressLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cardView.backgroundColor = UIColor.white
        self.cardView.layer.masksToBounds =  false
        self.cardView.layer.cornerRadius = 3.0
        self.cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.cardView.layer.shadowOpacity = 0.8
        self.cardView.layer.shadowOffset = CGSize.zero
        self.contentView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.96, alpha:1.00)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
