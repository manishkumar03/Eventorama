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
        let callingVC = String(describing: type(of: self))
      
        if callingVC != "UINavigationController" {
            EventTracker.sharedInstance.trackEvent(eventName: "view loaded")
            debugPrint("Swizzleeee. Call NEW view did load ")
            print("View loaded in \(callingVC)")
        }
    }
    
    @objc func ER_viewDidAppear() {
        self.ER_viewDidAppear()
        let callingVC = String(describing: type(of: self))
        
        if callingVC != "UINavigationController" {
            debugPrint("Swizzleeee. Call NEW view did appear", callingVC)
            
            view.backgroundColor = .blue
        }

    }
    
    static func startSwizzlingUIViewController() {
        var selectors: [(String, Selector, Selector)] = []
        let selectorsViewLoad = ("viewDidLoad",
                                 #selector(viewDidLoad),
                                 #selector(ER_viewDidLoad))
        selectors.append(selectorsViewLoad)
        
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

