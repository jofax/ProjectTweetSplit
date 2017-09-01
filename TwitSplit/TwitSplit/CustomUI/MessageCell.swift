//
//  MessageCell.swift
//  TwitSplit
//
//  Created by Joseph on 30/8/17.
//  Copyright © 2017 Others. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var lblMessage: UILabel!
    var message: Messages? {
        didSet {
            if let data = message {
                lblMessage.text = data.message
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        guard lblMessage != nil else {
            return
        }
        
        lblMessage.text = ""
    }
    
}
