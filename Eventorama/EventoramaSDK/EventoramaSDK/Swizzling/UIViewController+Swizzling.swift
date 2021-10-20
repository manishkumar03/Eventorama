//
//  UIViewController+Swizzling.swift
//  EventoramaSDK
//
//  Created by Manish Kumar on 2021-10-20.
//

import UIKit

extension UIViewController {
    
    func pretty_function(_ file: String = #file, function: String = #function, line: Int = #line) {
        print("file:\(file) function:\(function) line:\(line)")
    }
    
    @objc func ER_viewDidLoad() {
        self.ER_viewDidLoad()
        
        let screensToIgnore = ["UISystemKeyboardDockController",
                               "UICompatibilityInputViewController",
                               "UIInputWindowController",
                               "UISystemInputAssistantViewController",
                               "ACVTabBarController",
                               "UINavigationController"]
        
        let callingVC = String(describing: type(of: self))
      
        if !screensToIgnore.contains(callingVC) {
            var props: [String: String] = [:]
            props["screenName"] = callingVC
            props["uiElementType"] = "ViewController"
            props["uiElementLabel"] = "NA"
            props["uiActionTaken"] = "NA"
            EventTracker.sharedInstance.trackEvent(eventName: "view loaded", props: props)
           
            debugPrint("Swizzleeee. Call NEW view did load ")
        }
    }
    
    @objc func ER_viewDidAppear() {
        self.ER_viewDidAppear()
        let screensToIgnore = ["UISystemKeyboardDockController",
                               "UICompatibilityInputViewController",
                               "UIInputWindowController",
                               "UISystemInputAssistantViewController",
                               "ACVTabBarController",
                               "UINavigationController"]
        
        let callingVC = String(describing: type(of: self))
        
        if !screensToIgnore.contains(callingVC) {
            var props: [String: String] = [:]
            props["screenName"] = callingVC
            props["uiElementType"] = "ViewController"
            props["uiElementLabel"] = "NA"
            props["uiActionTaken"] = "NA"
            EventTracker.sharedInstance.trackEvent(eventName: "view appeared", props: props)
            
            debugPrint("Swizzleeee. Call NEW view did appear", callingVC)
        }
    }
    
    static func startSwizzlingUIViewController() {
        var selectors: [(String, Selector, Selector)] = []
//        let selectorsViewLoad = ("viewDidLoad",
//                                 #selector(viewDidLoad),
//                                 #selector(ER_viewDidLoad))
//        selectors.append(selectorsViewLoad)
        
        let selectorsViewDidAppear = ("viewDidAppear",
                                      #selector(viewDidAppear(_:)),
                                      #selector(ER_viewDidAppear))
        selectors.append(selectorsViewDidAppear)
        
        for (lifecycleMethod, defaultSelector, newSelector) in selectors {
            let defaultInstace = class_getInstanceMethod(UIViewController.self, defaultSelector)
            let newInstance = class_getInstanceMethod(UIViewController.self, newSelector)

            if let instance1 = defaultInstace, let instance2 = newInstance {
                debugPrint("Swizzlle for \(lifecycleMethod) success")
                method_exchangeImplementations(instance1, instance2)
            }
        }
    }
}

