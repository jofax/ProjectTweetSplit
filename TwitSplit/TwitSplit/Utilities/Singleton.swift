//
//  Singleton.swift
//  TwitSplit
//
//  Created by Joseph on 30/8/17.
//  Copyright © 2017 Others. All rights reserved.
//

import UIKit

typealias   CLOSURE_SUCCESS     =   (_ response: Any?) -> Void
typealias   CLOSURE_FAIL        =   (_ response: Error?) -> Void

enum DataProcessError: Error {
    case invalidData
    case coreDataError
    case persistentDataError
}

struct Constants {
    static let numberOfCharacters: Int       =   50
}

class Singleton: NSObject {
    static let sharedInstance = Singleton()
    override fileprivate init () {}
    
    func showAlert(controller: UIViewController,
                   title: String,
                   message: String,
                   action: UIAlertAction) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(action)
        controller.present(alertController, animated: true, completion:nil)
    }
    
    
    
}
