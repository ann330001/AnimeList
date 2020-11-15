//
//  FavoriteVC.swift
//  AnimeList
//
//  Created by Ann on 2020/11/15.
//  Copyright © 2020 AnnChen.com. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let tableViewHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        //register notification
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(updateTable(notification:)),
                           name: NSNotification.Name(rawValue: "remoe_update"),
                           object: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
        getDataReloadTable()
    }
    
    @objc func updateTable(notification: NSNotification) {
        getDataReloadTable()
    }

    func getDataReloadTable() {
        CoreDataManager.instance.fetchItem()
        tableView.reloadData()
    }
    
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.instance.favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        let item = CoreDataManager.instance.favoriteItems[indexPath.row]
        
        cell.initUI(height: tableViewHeight)
        cell.topItem = item
        cell.titleLabel.text = item.title
        cell.typeLabel.text = "Type: \(item.type ?? "")"
        cell.rankLabel.text = "rank: \(item.rank)"
        cell.dateLabel.text = "Date: \(item.start_date ?? "") - \(item.end_date ?? "")"
        cell.imageURL = item.image_url
        
        APIManager.instance.downloadImage(url: item.image_url!){ (image) in
            if cell.imageURL == item.image_url, let img = image {
                DispatchQueue.main.async {
                    cell.imgView.image = img
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topItem = CoreDataManager.instance.favoriteItems[indexPath.row]
        if let url = URL.init(string: topItem.url ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}
