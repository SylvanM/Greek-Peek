//
//  RouteTableViewCell.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 4/20/22.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var route: Route! {
        didSet {
            nameLabel.text = route.name
            switch route.difficulty {
            case .green:
                difficultyLabel.text = "🟢"
            case .blue:
                difficultyLabel.text = "🟦"
            case .black:
                difficultyLabel.text = "⬛️"
            case .doubleBlack:
                difficultyLabel.text = "⬛️⬛️"
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
