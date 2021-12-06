//
//  TodoCell.swift
//  ToDo
//
//  Created by Abeer Alfaifi on 12/1/21.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoCreationDate: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
