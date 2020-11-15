//
//  TopTableViewCell.swift
//  AnimeList
//
//  Created by Ann on 2020/11/14.
//  Copyright © 2020 AnnChen.com. All rights reserved.
//

import UIKit

class TopTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var imageURL: URL!
    var topItem: Top?
    private var isFavorite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // initUI by program
    func initUI(height: CGFloat) {
        isFavorite = false
        let w = UIScreen.main.bounds.size.width
        
        imgView.frame = CGRect(x: 5, y: 5, width: w/2 - 10, height: height - 10)
        
        titleLabel.frame = CGRect(x: w/2, y: 0, width: w/2, height: height*2/5)
        titleLabel.backgroundColor = UIColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 0.4)
        
        typeLabel.frame = CGRect(x: w/2, y: height*2/5, width: w, height: height/5)
        rankLabel.frame = CGRect(x: w/2, y: height*3/5, width: w, height: height/5)
        dateLabel.frame = CGRect(x: w/2, y: height*4/5, width: w, height: height/5)
        
        favoriteBtn.frame = CGRect(x: w-30, y: 0, width: 30, height: height)
        favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteBtn.addTarget(self, action: #selector(pressedFavoriteBtn), for: .touchUpInside)
    }
    @objc func pressedFavoriteBtn() {
        if !isFavorite {
            if let item = topItem {
                let result = CoreDataManager.instance.addNewItem(topItem: item)
                if result {
                    favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    isFavorite = true
                }
            }
        } else {
            if let id = topItem?.mal_id {
                CoreDataManager.instance.deleteItem(id: id)
                favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                isFavorite = false
            }
        }
    }
    
}
