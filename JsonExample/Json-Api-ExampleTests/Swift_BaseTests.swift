//
//  Swift_BaseTests.swift
//  Json-Api-ExampleTests
//
//  Created by Kruperfone on 22.09.15.
//  Copyright © 2015 Flatstack. All rights reserved.
//

import XCTest
@testable import Swift_Base

class Swift_BaseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    func testApiGetRequest() {
        let expect = self.expectation(description:"completion handler called")
        let manager = APIManager.sharedInstance.manager
        let params = ["show_env":1]
        _ = try! manager.API_GET("get", params: params as AnyObject? , success: { (task, response) in
            print("Result: \(response)")
            expect.fulfill()
            }, failure: { (task, error) in
            print("Error: \(error)")
        })
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
    func testApiPostRequest() {
        let expect = self.expectation(description: "completion handler called")
        let manager = APIManager.sharedInstance.manager
        let params = ["show_env":1]
        _ = try! manager.API_POST("post", params: params as AnyObject?, success: { (task, response) in
            print("Result: \(response)")
            expect.fulfill()
            }, failure: { (operation, error) -> Void in
            print("Error: \(error)")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }

}
