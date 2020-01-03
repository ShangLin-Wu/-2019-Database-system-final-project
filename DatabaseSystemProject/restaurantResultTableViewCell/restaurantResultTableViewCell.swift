//
//  restaurantResultTableViewCell.swift
//  DatabaseSystemProject
//
//  Created by 吳尚霖 on 11/28/19.
//  Copyright © 2019 吳尚霖. All rights reserved.
//

import UIKit

class restaurantResultTableViewCell: UITableViewCell {
    
    @IBOutlet var storeImage: UIImageView!
    @IBOutlet var storeName: UILabel!
    @IBOutlet var storeComment: UILabel!
    @IBOutlet var storeAddress: UILabel!
    @IBOutlet var storeTel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(res:getRestaurantRes , indexPath:IndexPath) -> Void {
        self.storeImage.image = nil
        
        DispatchQueue.global().async {
            if let url = URL(string: (res.results.content[indexPath.row].photo)!){
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async
                        {
                            self.storeImage.image = UIImage(data: data)
                    }
                }
            }
        }
        
        storeName.text = res.results.content[indexPath.row].name
        storeComment.text = res.results.content[indexPath.row].reviews[0].text
        storeTel.text = res.results.content[indexPath.row].phone
        storeAddress.text = res.results.content[indexPath.row].vicinity
    }
    
}
