//
//  EventoramaSDKTests.swift
//  EventoramaSDKTests
//
//  Created by Manish Kumar on 2021-10-20.
//

import XCTest
@testable import EventoramaSDK

class EventoramaSDKTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_eventFired_capturedByStorageManager() throws {
        // Given
        let eventTracker = EventTracker.sharedInstance
        let storageManager = MockStorageManager()
        eventTracker.storageManager = storageManager
        
        // When
        eventTracker.trackEvent(eventName: "Testing SDK")
        
        // Then
        XCTAssertTrue(storageManager.capturedEvents.contains("Testing SDK"), "The event could not be captured")
    }
}
