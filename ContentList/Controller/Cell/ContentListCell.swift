//
//  ContentListCell.swift
//  ContentList
//
//  Created by Muhammad Riaz on 15/09/2021.
//

import UIKit
import SkeletonView

class ContentListCell: UITableViewCell {
    
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var itemBgView: UIView!{
        didSet{
            itemBgView.layer.cornerRadius = 12.0
        }
    }
    
    class var reuseIdentifier: String {
        return "ContentListCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
