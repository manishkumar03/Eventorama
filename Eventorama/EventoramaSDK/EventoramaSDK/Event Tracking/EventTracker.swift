//
//  EventTracker.swift
//  EventoramaSDK
//
//  Created by Manish Kumar on 2021-10-20.
//

import UIKit
import CoreData

protocol EventTrackingProtocol {
    func trackEvent(eventName: String, props: [String: String])
}

public class EventTracker: EventTrackingProtocol {
    public static let sharedInstance = EventTracker()
    var storageManager: LocalStorageProtocol = StorageManager.sharedInstance
    var networkingClient = NetworkingClient()
    
    /// Used to send captured events to the backend on a schedule (every 10 seconds)
    var uploadTimer: Timer?

    
    /// Subscribe to the notified when the app becomes active or goes to background.
    private init() {
        activateUploadTimer()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(activateUploadTimer), name: UIApplication.didBecomeActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(deactivateUploadTimer), name: UIApplication.willResignActiveNotification, object: nil)
        
        // Swizzling for automatic tracking
        UIViewController.startSwizzlingUIViewController()
    }
    
    /// Capture the event and store it in the local storage.
    /// - Parameter eventName: The name of the event which is to be captured
    public func trackEvent(eventName: String, props: [String: String] = [:]) {
        if let event = storageManager.createNewEvent(action: eventName) {
            event.id = UUID().uuidString
            event.timestamp = Date().timeIntervalSince1970
            event.appBuildNumber = Bundle.main.appBuildNumber
            event.appVersionNumber = Bundle.main.appVersionNumber
            event.osVersion = UIDevice.current.systemVersion
            event.platform = "iOS"
            event.screenName = "NA"
            event.uiElementType = "NA"
            event.uiElementLabel = "NA"
            event.uiActionTaken = "NA"
            
            for (key, value) in props {
                switch key {
                    case "screenName":
                        event.screenName = value
                    case "uiElementType":
                        event.uiElementType = value
                    case "uiElementLabel":
                        event.uiElementLabel = value
                    case "uiActionTaken":
                        event.uiActionTaken = value
                    default:
                        print("abc")
                }
            }
            storageManager.saveEvent()
        }
    }
    
    /// Start the timer to send captured events to the backend on a schedule (every 10 seconds). The timer will be started everytime the host app either
    /// starts cold or becomes active again.
    @objc func activateUploadTimer() {
        if let timer = uploadTimer, timer.isValid {
            // Do nothing
        } else {
            uploadTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(postEventsToServer), userInfo: nil, repeats: true)
            print("Upload timer activated")
        }
    }
    
    /// Stop the timer to send captured events to the backend on a schedule. The timer will be deactivated everytime the host app becomes inactive.
    @objc func deactivateUploadTimer() {
        uploadTimer?.invalidate()
        print("Upload timer deactivated")
    }
    
    /// Send the captured events to the backend. After the events have been sent successfully, delete them from the local storage.
    /// If the events cannot be sent successfully, they'll remain in the local storage and will be sent on subsequent calls.
    @objc func postEventsToServer() {
        if let erEvents = storageManager.fetchEvents(), erEvents.count > 0 {
            let eventArray = storageManager.createEventsDictionary(erEvents: erEvents)
            networkingClient.postEvents(params: eventArray) { success in
                print("Events sent successfully")
                self.storageManager.deleteEvents(erEvents: erEvents)
            } onError: { failure in
                print("Events could not be sent")
            }
        }
    }
}
