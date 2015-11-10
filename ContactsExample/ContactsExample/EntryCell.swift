//
//  EntryCell.swift
//  Contacts
//
//  Created by Marco Bonato on 10/11/15.
//  Copyright © 2015 Vooice. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    @IBOutlet weak var name_surname: UILabel!
    @IBOutlet weak var phone_number: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
