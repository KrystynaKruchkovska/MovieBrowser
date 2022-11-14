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
        
        let testCases = [127, 10, 0, -50, 20_000]
        let expectedResults = ["2h 7m","10m","0m", "0m", "333h 20m"]
        
    
        for i in 0...testCases.count-1 {
            let testCase = testCases[i]
            let expectedResult = expectedResults[i]
            let actualResult = MovieCellViewModel.culculateMovieDuration(runtime: testCase)
            
            XCTAssertEqual(actualResult, expectedResult, "Invalid calculation")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
