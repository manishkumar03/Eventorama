//
//  Bundle+Extension.swift
//  EventoramaSDK
//
//  Created by Manish Kumar on 2021-10-20.
//

import Foundation

extension Bundle {
    var appVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var appBuildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}

