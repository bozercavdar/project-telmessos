//
//  CommentTableViewCell.swift
//  ku-add-drop
//
//  Created by Lab on 17.01.2022.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var givenCourseScoreLabel: UILabel!
    
    @IBOutlet weak var commentContentLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
