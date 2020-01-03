//
//  reviewTableViewCell.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 12/28/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import UIKit

class reviewTableViewCell: UITableViewCell {

    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(res:restaurant_Content_Reviews){
        self.userName.text = res.name
        self.userReview.text = res.text
        let url = URL(string: res.photo!)
        self.profilePhoto.sd_setImage(with: url, placeholderImage:UIImage(named: "loadingImage"))
    }
}
