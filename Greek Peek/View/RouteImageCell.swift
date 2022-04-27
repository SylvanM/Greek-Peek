//
//  RouteImageCell.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 4/27/22.
//

import UIKit

class RouteImageCell: UICollectionViewCell {
    
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
}
