//
//  SwitchTests.swift
//  SwitchTests
//
//  Created by Thanh Pham on 9/9/16.
//  Copyright © 2016 TPM. All rights reserved.
//

import XCTest
@testable import Switch

class SwitchTests: XCTestCase {

    var theSwitch: Switch!

    override func setUp() {
        super.setUp()
        theSwitch = Switch()
    }

    override func tearDown() {
        theSwitch = nil
        super.tearDown()
    }

    func testLeftText() {
        let text = "left"
        theSwitch.leftText = text
        XCTAssertEqual(theSwitch.leftLabel.text, text)
    }

    func testRightText() {
        let text = "right"
        theSwitch.leftText = text
        XCTAssertEqual(theSwitch.leftLabel.text, text)
    }

    func testDisabledColor() {
        let color = UIColor.cyanColor()
        theSwitch.disabledColor = color
        XCTAssert(CGColorEqualToColor(theSwitch.backgroundLayer.borderColor, color.CGColor))
        XCTAssertEqual(theSwitch.rightLabel.textColor, color)
    }

    func testTintColor() {
        let color = UIColor.purpleColor()
        theSwitch.tintColor = color
        XCTAssert(CGColorEqualToColor(theSwitch.switchLayer.borderColor, color.CGColor))
        XCTAssertEqual(theSwitch.leftLabel.textColor, color)
    }
}
