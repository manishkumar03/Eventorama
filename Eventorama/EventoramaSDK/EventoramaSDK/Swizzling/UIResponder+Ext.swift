//
//  UIResponder+Ext.swift
//  EventoramaSDK
//
//  Created by Manish Kumar on 2021-10-20.
//

import UIKit

extension UIResponder {
    
    /// Find the parent `UIViewController` which contains the `UIControl` the user is interacting with
    /// - Parameter condition: The type of `UIViewController` which is to be found
    /// - Returns: The parent `UIViewController` containing this `UIControl`
    func nextFirstResponder(where condition: (UIResponder) -> Bool ) -> UIResponder? {
        guard let next = next else { return nil }
        if condition(next) {
            return next
        }
        else {
            return next.nextFirstResponder(where: condition)
        }
    }
}
