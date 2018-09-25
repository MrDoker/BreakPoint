//
//  FirstViewController.swift
//  BreakPoint
//
//  Created by DokeR on 12.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messagesArray = [Message]()
    var newMessagesArray = [NewMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataService.instance.getAllFeedMessagesNewWay(handler: { (messages) in
            self.newMessagesArray = messages.reversed()
            self.tableView.reloadData()
        })
        DataService.instance.observeFeedForNewMessages { (newMessage) in
            guard let lastMessageInArray = self.newMessagesArray.first else {return}
            if lastMessageInArray.key != newMessage.key {
                self.newMessagesArray.insert(newMessage, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newMessagesArray.count
        //return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedTableViewCell {
            let message = newMessagesArray[indexPath.row]
            cell.configCell(email: message.senderEmail, message: message.content)
            cell.profileImageView.loadImageUsingCacheWithUrlString(message.senderImageURL)
            return cell
        }
        return UITableViewCell()
    }
}

