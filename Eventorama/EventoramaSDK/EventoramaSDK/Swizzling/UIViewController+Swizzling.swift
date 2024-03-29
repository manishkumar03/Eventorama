//
//  UIViewController+Swizzling.swift
//  EventoramaSDK
//
//  Created by Manish Kumar on 2021-10-20.
//

import UIKit

extension UIViewController {
    
    @objc func swizzled_viewDidLoad() {
        self.swizzled_viewDidLoad()
        
        let screensToIgnore = ["UISystemKeyboardDockController",
                               "UICompatibilityInputViewController",
                               "UIInputWindowController",
                               "UISystemInputAssistantViewController",
                               "ACVTabBarController",
                               "UINavigationController",
                               "SettingsFooterViewController",
                               "SettingsTableViewController",
                               "SettingsDetailViewController",
                               "SettingsDetailTableViewController",
                               "UIPredictionViewController",
                               "SBSOverlayController",
                               "SBSBarcodePicker",
                               "MyACVMenuHeaderViewController",
                               "MenuTableViewController",
                               "BackClosingModalViewController",
                               "MyACVFlagSwitchingViewController",
                               "UINavigationController"
        ]
        
        let callingVC = String(describing: type(of: self))
        
        if !screensToIgnore.contains(callingVC) {
            var props: [String: String] = [:]
            props["screenName"] = callingVC
            props["uiElementType"] = "ViewController"
            props["uiElementLabel"] = self.title
            props["uiActionTaken"] = "NA"
            EventTracker.sharedInstance.trackEvent(eventName: "view loaded", props: props)
            debugPrint("Swizzled-viewDidLoad-\(callingVC)")
        }
    }
    
    @objc func swizzled_viewDidAppear() {
        self.swizzled_viewDidAppear()
        
        let screensToIgnore = ["UISystemKeyboardDockController",
                               "UICompatibilityInputViewController",
                               "UIInputWindowController",
                               "UISystemInputAssistantViewController",
                               "ACVTabBarController",
                               "UINavigationController",
                               "SettingsFooterViewController",
                               "SettingsTableViewController",
                               "SettingsDetailViewController",
                               "SettingsDetailTableViewController",
                               "UIPredictionViewController",
                               "SBSOverlayController",
                               "SBSBarcodePicker",
                               "MyACVMenuHeaderViewController",
                               "MenuTableViewController",
                               "BackClosingModalViewController",
                               "MyACVFlagSwitchingViewController",
                               "UINavigationController"
        ]
        
        let callingVC = String(describing: type(of: self))
        
        if !screensToIgnore.contains(callingVC) {
            var props: [String: String] = [:]
            props["screenName"] = callingVC
            props["uiElementType"] = "ViewController"
            props["uiElementLabel"] = self.title
            props["uiActionTaken"] = "NA"
            EventTracker.sharedInstance.trackEvent(eventName: "view appeared", props: props)
            debugPrint("Swizzled-viewDidAppear-\(callingVC)")
        }
    }
    
    static func startSwizzlingUIViewController() {
        var selectors: [(String, Selector, Selector)] = []
        
        /// Uncomment the following lines to track `viewDidLoad` events
        //        let selectorViewLoad = ("viewDidLoad",
        //                                 #selector(viewDidLoad),
        //                                 #selector(swizzled_viewDidLoad))
        //        selectors.append(selectorViewLoad)
        
        let selectorViewDidAppear = ("viewDidAppear",
                                      #selector(viewDidAppear(_:)),
                                      #selector(swizzled_viewDidAppear))
        selectors.append(selectorViewDidAppear)
        
        for (lifecycleMethod, defaultSelector, newSelector) in selectors {
            let defaultInstace = class_getInstanceMethod(UIViewController.self, defaultSelector)
            let newInstance = class_getInstanceMethod(UIViewController.self, newSelector)
            
            if let instance1 = defaultInstace, let instance2 = newInstance {
                debugPrint("Swizzling set up successfully for \(lifecycleMethod)")
                method_exchangeImplementations(instance1, instance2)
            }
        }
    }
}

