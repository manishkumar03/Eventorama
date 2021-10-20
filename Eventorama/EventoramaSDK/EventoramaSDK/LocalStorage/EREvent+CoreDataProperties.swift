//
//  EREvent+CoreDataProperties.swift
//  EventoramaApp
//
//  Created by Manish Kumar on 2021-10-20.
//
//

import Foundation
import CoreData


extension EREvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EREvent> {
        return NSFetchRequest<EREvent>(entityName: "EREvent")
    }

    @NSManaged public var appBuildNumber: String?
    @NSManaged public var appVersionNumber: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var osVersion: String?
    @NSManaged public var platform: String?
    @NSManaged public var timestamp: Double
    @NSManaged public var screenName: String?
    @NSManaged public var uiElementType: String?
    @NSManaged public var uiElementLabel: String?
    @NSManaged public var uiActionTaken: String?

}
