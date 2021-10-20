//
//  UIResponder+Ext.swift
//  EventoramaSDK
//
//  Created by Manish Kumar on 2021-10-20.
//

import UIKit

extension UIResponder {
    func nextFirstResponder(where condition: (UIResponder) -> Bool ) -> UIResponder? {
        guard let next = next else { return nil }
        if condition(next) { return next }
        else { return next.nextFirstResponder(where: condition) }
    }
}
