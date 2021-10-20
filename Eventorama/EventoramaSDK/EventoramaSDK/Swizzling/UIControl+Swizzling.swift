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
        print("Control pressed in \(parentVC!.classForCoder)")
        //print(sender.titleLabel?.text)
        
        switch self {
            case is UIButton:
                if let myButton = sender as? UIButton {
                    print(myButton.titleLabel?.text)
                    print(myButton.accessibilityLabel)
                }
                
            case is UISwitch:
                if let mySwitch = sender as? UISwitch {
                    print(mySwitch.isOn)
                }
            default:
                print("none of the above")
        }
    }
}

