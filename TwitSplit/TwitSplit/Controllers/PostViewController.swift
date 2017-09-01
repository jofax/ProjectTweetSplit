//
//  ViewController.swift
//  TwitSplit
//
//  Created by Joseph on 30/8/17.
//  Copyright © 2017 Others. All rights reserved.
//

import UIKit

protocol PostControllerDelegate: NSObjectProtocol {
    func reloadMessages()
}

class PostViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    weak var postDelegate: PostControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addDoneButtonOnKeyboard()

        ///Register Keyboard Notifications
        registerKeyboardNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    @IBAction func onBtnClosePostController(sender: UIButton) {
        self.textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func keyboardWillShowForResizing(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        } else {
            debugPrint("Where showing the keyboard but the size is nil!")
        }
    }
    
    func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("Where hiding the keyboard but the size is nil!")
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.done, target: self, action: #selector(postMessage))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.textView.inputAccessoryView = doneToolbar
        
    }
    
    func postMessage() {
        let message = self.textView.text
        guard message?.isEmpty == false else {
            let action = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                
            })
            Singleton.sharedInstance.showAlert(controller: self, title: "Error", message: "Yoh!, message should not be empty!", action: action)
            return
        }
        
        if (message?.characters.count)! < Constants.numberOfCharacters {
            let queue = DispatchQueue(label: "com.twitsplit.queue", qos: DispatchQoS.userInitiated)
            
            queue.sync {
                let post = Messages.saveMessage(message: message!)
                if post {
                    self.postDelegate.reloadMessages()
                }
                
                DispatchQueue.main.async {
                   self.dismiss(animated: true, completion: nil)
                }
            }
            
        } else {
            let whitespace = CharacterSet.whitespaces
            guard message?.rangeOfCharacter(from: whitespace) != nil else {
                let action = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    
                })
                Singleton.sharedInstance.showAlert(controller: self, title: "Error", message: "Oh my, you need to have a whitespace on each words.", action: action)
                return
            }
            self.splitMessageToChunks(message: message!)
        }
        
    }
    
    ///Split messages into chunks and save it on core data
    func splitMessageToChunks(message: String) {
        let total = Double(message.characters.count) / Double(Constants.numberOfCharacters)
        let total_chunks = total.rounded(.up)
        var startIndex = 0
        
        let workItem = DispatchWorkItem {
            for i in 1...Int(total_chunks) {
                var indicator = self.createChunkIndicator(offset: i, total: Int(total_chunks))
                let chunk = message.substring(from: startIndex, length: Constants.numberOfCharacters - indicator.characters.count)
                let chunk_string = indicator + chunk
                
                let post = Messages.saveMessage(message: chunk_string)
                if post {
                    self.postDelegate.reloadMessages()
                }
                
                startIndex += Constants.numberOfCharacters - indicator.characters.count
            }
        }
        
        let queue = DispatchQueue.global()
        queue.async {
            workItem.perform()
        }
        workItem.notify(queue: DispatchQueue.main) {
            self.postDelegate.reloadMessages()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func createChunkIndicator(offset: Int, total: Int) -> String {
        return String(format: "%d/%d ", offset,total)
    }
    
}

