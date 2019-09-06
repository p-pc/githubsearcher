//
//  ReposTableViewCell.swift
//  tmobilegit
//
//  Created by Parthiban on 9/6/19.
//  Copyright © 2019 Ossum. All rights reserved.
//

import UIKit

class ReposTableViewCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
