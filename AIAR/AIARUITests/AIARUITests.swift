//
//  AIARUITests.swift
//  AIARUITests
//
//  Created by 陈若鑫 on 31/01/2024.
//

import XCTest

final class AIARUITests: XCTestCase {

    override func setUpWithError() throws {
            continueAfterFailure = false
        }

        override func tearDownWithError() throws {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
        }

        func testLandingPageUI() throws {
            let app = XCUIApplication()
            app.launch()

            // Test the existence of a button with accessibility identifier "Instructions"
            XCTAssertTrue(app.buttons["Instructions"].exists)

            app.buttons["Instructions"].tap()
        }

        func testLaunchPerformance() throws {
            if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
                measure(metrics: [XCTApplicationLaunchMetric()]) {
                    XCUIApplication().launch()
                }
            }
        }
}
