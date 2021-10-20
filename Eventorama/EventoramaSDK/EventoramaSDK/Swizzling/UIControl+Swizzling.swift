//
//  UIControl+Swizzling.swift
//  EventoramaSDK
//
//  Created by Manish Kumar on 2021-10-20.
//

import UIKit

extension UIControl {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(globalUIButonAction), for: .touchUpInside)
    }

    @objc func globalUIButonAction (_ sender: UIControl) {
        let parentVC = sender.nextFirstResponder { $0 is UIViewController }
        
        var props: [String: String] = [:]
        if let parentVC = parentVC {
            props["screenName"] = "\(parentVC.classForCoder)"
        }
        
        props["uiElementType"] = type(of: sender).description()
        props["uiElementLabel"] = sender.accessibilityIdentifier

        switch self {
            case is UIButton:
                if let myButton = sender as? UIButton {
                    props["uiActionTaken"] = "button pressed"
                    EventTracker.sharedInstance.trackEvent(eventName: "button pressed", props: props)
                }
                
            case is UISwitch:
                if let mySwitch = sender as? UISwitch {
                    props["uiActionTaken"] = mySwitch.isOn ? "switch turned on" : "switch turned off"
                    EventTracker.sharedInstance.trackEvent(eventName: "switch toggled", props: props)
                }
                
            default:
                print("none of the above")
        }
    }
}

