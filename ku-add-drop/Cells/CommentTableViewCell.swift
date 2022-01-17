//
//  CommentTableViewCell.swift
//  ku-add-drop
//
//  Created by Lab on 17.01.2022.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var GivenCourseScoreLabel: UILabel!
    
    @IBOutlet weak var CommentContentLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
