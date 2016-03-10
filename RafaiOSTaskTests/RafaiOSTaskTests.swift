//
//  RafaiOSTaskTests.swift
//  RafaiOSTaskTests
//
//  Created by Saraceni on 2/12/16.
//  Copyright © 2016 rafa. All rights reserved.
//

import XCTest
import Alamofire
@testable import RafaiOSTask

class RafaiOSTaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAPIResponse()
    {
        let readyExpectation = expectationWithDescription("ready")
        
        ////Client-ID 880e28f546ce662
        
        let header = [
            "Authorization": "Client-ID 880e28f546ce662=="
        ]
        
        Alamofire.request(.GET, "https://api.imgur.com/3/gallery/0/hot/0?showViral=false", headers: header)
            .responseJSON { (response) in
                XCTAssertNotNil(response)
                print(response)
        
                readyExpectation.fulfill()
            }
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
