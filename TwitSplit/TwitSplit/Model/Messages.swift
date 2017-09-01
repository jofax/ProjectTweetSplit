//
//  Messages.swift
//  TwitSplit
//
//  Created by Joseph on 30/8/17.
//  Copyright © 2017 Others. All rights reserved.
//

import UIKit
import CoreData

/*!
 @brief Message Model.
 @description NSManageObject model for Messages Entity.
 @param  none
 @return none
 */

@objc(Messages)

class Messages: NSManagedObject {
    
    ///Messages Model Properties
    @NSManaged public var id: Int64
    @NSManaged public var message: String?
    
    /*!
     @brief class func getMessages() -> [Messages]
     @description retrieves array of messages from core data.
     @param  none
     @return array of Messages object
     */
    
    class func getMessages() -> [Messages] {
        let modelProperty = ModelProperty.init()
        let moc = DataController.managedObjectContext
        let messages = NSFetchRequest<NSFetchRequestResult>(entityName: modelProperty.modelName)
        
        do {
            let messages_array = try moc.fetch(messages) as! [Messages]
            return messages_array
        } catch {
            fatalError("Failed to fetch \(modelProperty.modelName): \(error)")
        }

    }
 
    /*!
     @brief class func saveMessage(message: String) -> Bool
     @description save message to the local storage.
     @param  message as String
     @return boolean
     */
    
    class func saveMessage(message: String) -> Bool {
        
        let modelProperty = ModelProperty.init()
        let entityDesc = NSEntityDescription.entity(forEntityName: modelProperty.modelName,
                                                    in: DataController.managedObjectContext)
        let model = Messages(entity: entityDesc!, insertInto: DataController.managedObjectContext)
        model.message = message
        let response = DataController.saveContext()
        
        guard response is DataProcessError else {
            return false
        }
        
        return response as! Bool
    }
    
}
