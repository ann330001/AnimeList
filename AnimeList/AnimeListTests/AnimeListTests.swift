//
//  AnimeListTests.swift
//  AnimeListTests
//
//  Created by Ann on 2020/11/14.
//  Copyright © 2020 AnnChen.com. All rights reserved.
//

import XCTest
@testable import AnimeList

class AnimeListTests: XCTestCase {
    
    var urlSession: URLSession!
    
    override func setUpWithError() throws {
        urlSession = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        urlSession = nil
    }

    // test web API
    func testCallToAPIComplete() {
        callTo(urlString: "https://api.jikan.moe/v3/top/anime/1/upcoming")
    }

    func callTo(urlString: String) {
        /// given
        let url = URL(string: urlString)
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?

        // when
        let dataTask = urlSession.dataTask(with: url!) { (data, response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
}
