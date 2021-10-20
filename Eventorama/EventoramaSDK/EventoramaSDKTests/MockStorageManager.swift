//
//  MockStorageManager.swift
//  EventoramaSDKTests
//
//  Created by Manish Kumar on 2021-10-20.
//

import Foundation
@testable import EventoramaSDK

class MockStorageManager: LocalStorageProtocol {
    var capturedEvents: [String] = []

    func createNewEvent(action: String) -> EREvent? {
        capturedEvents.append(action)
        return nil
    }
    
    func createEventsDictionary(erEvents: [EREvent]) -> [[String : Any]] {
        return [[:]]
    }
    
    func saveEvent() {
        capturedEvents.append("Testing SDK")
    }
    
    func fetchEvents() -> [EREvent]? {
        return nil
    }
    
    func deleteEvents(erEvents: [EREvent]) {
        /// Nothing for now
    }
}
