//
//  ViewController.swift
//  EventoramaApp
//
//  Created by Manish Kumar on 2021-10-20.
//

import UIKit
import EventoramaSDK

class FirstViewController: UIViewController {
    @IBOutlet weak var optForTrackingSwitch: UISwitch!
    
    let eventTracker = EventTracker.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changedTrackingOption(_ sender: UISwitch) {
        eventTracker.trackEvent(eventName: "Tracking option changed")
    }
    
    @IBAction func showDetailsButtonPressed(_ sender: UIButton) {
        eventTracker.trackEvent(eventName: "Show details pressed")
    }
    
}

