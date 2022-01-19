//
//  CourseInstructorTableViewCell.swift
//  ku-add-drop
//
//  Created by Lab on 17.01.2022.
//

import UIKit

class CourseInstructorTableViewCell: UITableViewCell {

    @IBOutlet weak var instructorNameLabel: UILabel!
    
    @IBOutlet weak var instructorScoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
