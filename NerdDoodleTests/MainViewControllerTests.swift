//
//  MainViewControllerTests.swift
//  NerdDoodleTests
//
//  Created by Vasiliy Kulakov on 9/21/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import XCTest
@testable import NerdDoodle

class MainViewControllerTests: XCTestCase {

    func testEmojis() {
//        🤩😎😀😁😂🤣😛😜😝😃😄😅😆😉😊😬😬😬🙂🙂🙂🙂😌🤔🤔🤔🤔🤔🤨🤨🤨🤨😐😑😯😶😣🤐😫😒😓😔😕🙃☹️🙁😖😞😟😭😦😧😩🤯🤯🤯🤯
        XCTAssertEqual("🤩", MainViewController.scoreToEmoji(score: 1.2))
        XCTAssertEqual("🤩", MainViewController.scoreToEmoji(score: 1.0))
        XCTAssertEqual("🤯", MainViewController.scoreToEmoji(score: 0.0))
        XCTAssertEqual("🤯", MainViewController.scoreToEmoji(score: -2.0))
    }
}
