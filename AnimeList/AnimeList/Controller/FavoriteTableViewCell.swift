//
//  FavoriteTableViewCell.swift
//  AnimeList
//
//  Created by Ann on 2020/11/15.
//  Copyright © 2020 AnnChen.com. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var imageURL: URL!
    var topItem: FavoriteItem?
    private var isFavorite = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // initUI by program
    func initUI(height: CGFloat) {
        let w = UIScreen.main.bounds.size.width
        
        imgView.frame = CGRect(x: 5, y: 5, width: w/2 - 10, height: height - 10)
        
        titleLabel.frame = CGRect(x: w/2, y: 0, width: w/2, height: height*2/5)
        titleLabel.backgroundColor = UIColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 0.4)
        
        typeLabel.frame = CGRect(x: w/2, y: height*2/5, width: w, height: height/5)
        rankLabel.frame = CGRect(x: w/2, y: height*3/5, width: w, height: height/5)
        dateLabel.frame = CGRect(x: w/2, y: height*4/5, width: w, height: height/5)
        
        favoriteBtn.frame = CGRect(x: w-30, y: 0, width: 30, height: height)
        favoriteBtn.addTarget(self, action: #selector(pressedFavoriteBtn), for: .touchUpInside)
    }
    
    @objc func pressedFavoriteBtn() {
        if isFavorite {
            if let id = topItem?.mal_id {
                CoreDataManager.instance.deleteItem(id: id)
                isFavorite = false
                
                let updateNotification = Notification.Name("remoe_update")
                NotificationCenter.default.post(name: updateNotification, object: nil)
            }
        }
    }

}
