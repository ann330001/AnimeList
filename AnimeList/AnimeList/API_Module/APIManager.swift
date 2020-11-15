//
//  APIManager.swift
//  AnimeList
//
//  Created by Ann on 2020/11/14.
//  Copyright © 2020 AnnChen.com. All rights reserved.
//

import Foundation
import UIKit

class APIManager
{
    static let instance = APIManager()
    // all top items from getTopList
    var topList:[Top] = []
    
    // get top items
    func getTopList(type: String, page: Int32, subtype: String) {
        let group = DispatchGroup()
        group.enter()
        
        let link = "https://api.jikan.moe/v3/top/\(type)/\(page)/\(subtype)"
        let url = URL(string: link)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let responseData = data,
                error == nil else
            {
                print("Error: dit not receive return data")
                group.leave()
                return
            }
            
            do {
                let result = try JSONDecoder().decode(RetrieveTopList.self, from: responseData)
                self.topList = result.top
                group.leave()
            }catch let error as NSError{
                print("Error parsing response")
                print("Catch Error: \(error)")
                group.leave()
                
                return
            }
        }
        task.resume()
        
        group.wait()
    }
    
    // download image from url
    func downloadImage(url: URL, handler: @escaping (UIImage?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                handler(image)
            } else {
                handler(nil)
            }
        }
        task.resume()
    }
}
