//
//  MovieBrowserTests.swift
//  MovieBrowserTests
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import XCTest
@testable import MovieBrowser

final class MovieBrowserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCulculateMovieDuration() throws {
        
        let movieDuration = MovieCellViewModel.culculateMovieDuration(runtime: 127)
        
        XCTAssertEqual(movieDuration, "2h 7m", "Should return 2h 7m")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
