//
//  APIManagerTests.swift
//  AnimeListTests
//
//  Created by Ann on 2020/11/15.
//  Copyright © 2020 AnnChen.com. All rights reserved.
//

import XCTest
@testable import AnimeList

class APIManagerTests: XCTestCase {
    
    var apiManager: APIManager!
    
    override func setUpWithError() throws {
        apiManager = APIManager()
    }

    override func tearDownWithError() throws {
        apiManager = nil
    }

    
    func testGetTopList() {
        apiManager.getTopList(type: "anime", page: 1, subtype: "upcoming")

        XCTAssertNotNil(apiManager.topList)
    }
    
    func testDownloadImg() {
        let url = URL.init(string: "https://cdn.myanimelist.net/images/anime/1777/108817.jpg?s=41a4d8c7ba0d2864b2489ebc9273e903")
        var img : UIImage? = nil
        let promise = expectation(description: "Completion handler invoked")
        
        apiManager.downloadImage(url: url!){ (image) in
            img = image
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        XCTAssertNotNil(img)
    }
}
