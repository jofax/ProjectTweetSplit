//
//  MessagesTableViewController.swift
//  TwitSplit
//
//  Created by Joseph on 30/8/17.
//  Copyright © 2017 Others. All rights reserved.
//

import UIKit

class MessagesTableViewController: UIViewController,
                                   UITableViewDelegate,
                                   UITableViewDataSource,
                                   PostControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var messages = [Messages]()
    
    lazy var postController: PostViewController =  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PostController") as! PostViewController
        controller.postDelegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.register(UINib(nibName: "MessageCell", bundle: nil),
                                forCellReuseIdentifier: "MessageCell")
        self.tableView.tableFooterView = nil
        
        self.messages = Messages.getMessages()
        self.tableView.reloadData()
    }
    
    @IBAction func onBtnPostMessage() {
        postController.registerKeyboardNotifications()
        self.present(postController, animated: false, completion: nil)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    }
 
    /// MARK : PostController Delegate
    func reloadMessages() {
        self.messages.removeAll()
        self.messages = Messages.getMessages()
        self.tableView.reloadData()
    }
}
