//
//  SecondViewController.swift
//  EventoramaApp
//
//  Created by Manish Kumar on 2021-10-20.
//

import UIKit
import EventoramaSDK

class SecondViewController: UIViewController {
    let eventTracker = EventTracker.sharedInstance

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventTracker.trackEvent(eventName: "Second screen appeared")
    }
}
