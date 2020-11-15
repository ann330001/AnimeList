//
//  SearchTopVC.swift
//  AnimeList
//
//  Created by Ann on 2020/11/14.
//  Copyright © 2020 AnnChen.com. All rights reserved.
//

import UIKit
import DropDown
//import DropDown

class SearchTopVC: UIViewController {
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var subtypeBtn: UIButton!
    @IBOutlet weak var pageBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let typeDropDown = DropDown()
    let subtypeDropDown = DropDown()
    let pageDropDown = DropDown()
    let tableViewHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitAction()
    }
    
    
    func setInitAction() {
        // get view size
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        // tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = self.view.backgroundColor
        
        var typeArray: [String] = []
        var subTypeArray: [String] = []
        var pageArray: [String] = []
        
        for value in TopType.allCases {
            typeArray.append(value.rawValue)
        }
        // typeBtn
        typeBtn.setTitle(TopType.anime.rawValue, for: .normal)
        typeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        typeBtn.addTarget(self, action: #selector(pressedTypeBtn), for: .touchUpInside)
        
        typeDropDown.anchorView = typeBtn
        typeDropDown.dataSource = typeArray
        typeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            subTypeArray.removeAll()
              if item == TopType.anime.rawValue {
                for value in TopSubtypeAnime.allCases {
                    subTypeArray.append(value.rawValue)
                }
              } else if item == TopType.manga.rawValue {
                for value in TopSubtypeManga.allCases {
                    subTypeArray.append(value.rawValue)
                }
              }
            for value in TopSubtypeBoth.allCases {
                subTypeArray.append(value.rawValue)
            }
            self.subtypeDropDown.dataSource = subTypeArray
            self.typeBtn.setTitle(item, for: .normal)
        }
        typeDropDown.width = 200
        typeDropDown.bottomOffset = CGPoint(x: 0, y:(typeDropDown.anchorView?.plainView.bounds.height)!)
        typeDropDown.selectRow(at: 0)
        
        // subtypeBtn
        subTypeArray.removeAll()
        for value in TopSubtypeAnime.allCases {
            subTypeArray.append(value.rawValue)
        }
        for value in TopSubtypeBoth.allCases {
            subTypeArray.append(value.rawValue)
        }
        subtypeDropDown.dataSource = subTypeArray
        
        subtypeBtn.setTitle(TopSubtypeAnime.upcoming.rawValue, for: .normal)
        subtypeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        subtypeBtn.addTarget(self, action: #selector(pressedSubtypeBtn), for: .touchUpInside)
        
        subtypeDropDown.anchorView = subtypeBtn
        subtypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.subtypeBtn.setTitle(item, for: .normal)
            
        }
        subtypeDropDown.width = 200
        subtypeDropDown.bottomOffset = CGPoint(x: 0, y:(subtypeDropDown.anchorView?.plainView.bounds.height)!)
        
        //pageBtn
        pageBtn.setTitle("1", for: .normal)
        pageBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        pageBtn.addTarget(self, action: #selector(pressedPageBtn), for: .touchUpInside)
        
        pageArray.removeAll()
        for page in 1...10 {
            pageArray.append("\(page)")
        }
        pageDropDown.anchorView = pageBtn
        pageDropDown.dataSource = pageArray
        pageDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.pageBtn.setTitle(item, for: .normal)
        }
        pageDropDown.width = 200
        pageDropDown.bottomOffset = CGPoint(x: 0, y:(pageDropDown.anchorView?.plainView.bounds.height)!)
        
        searchBtn.addTarget(self, action: #selector(pressedSearchBtn), for: .touchUpInside)
    }


    @objc func pressedTypeBtn() {
        typeDropDown.show()
    }
    @objc func pressedSubtypeBtn() {
        subtypeDropDown.show()
    }
    @objc func pressedPageBtn() {
        pageDropDown.show()
    }
    @objc func pressedSearchBtn() {
        let type = typeBtn.titleLabel?.text ?? ""
        let page = Int32(pageBtn.titleLabel?.text ?? "0") ?? 0
        let subtype = subtypeBtn.titleLabel?.text ?? ""
        APIManager.instance.getTopList(type: type, page: page, subtype: subtype)
        tableView.reloadData()
    }
}

extension SearchTopVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APIManager.instance.topList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopTableViewCell", for: indexPath) as! TopTableViewCell
        let topItem = APIManager.instance.topList[indexPath.row]
        
        cell.initUI(height: tableViewHeight)
        cell.topItem = topItem
        cell.titleLabel.text = topItem.title
        cell.typeLabel.text = "Type: \(topItem.type)"
        cell.rankLabel.text = "rank: \(topItem.rank)"
        cell.dateLabel.text = "Date: \(topItem.start_date ?? "") - \(topItem.end_date ?? "")"
        cell.imageURL = topItem.image_url
        
        APIManager.instance.downloadImage(url: topItem.image_url){ (image) in
            if cell.imageURL == topItem.image_url, let img = image {
                DispatchQueue.main.async {
                    cell.imgView.image = img
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topItem = APIManager.instance.topList[indexPath.row]
        if let url = URL.init(string: topItem.url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
