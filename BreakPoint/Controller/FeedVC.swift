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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.getAllFeedMessages { (messages) in
            self.messagesArray = messages.reversed()
            self.tableView.reloadData()
        }
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedTableViewCell {
            let message = messagesArray[indexPath.row]
            
            DataService.instance.getUserName(forUID: message.senderId) { (email) in
                DataService.instance.getUserAvatar(forUID: message.senderId) { (returnedImageURL) in
                    cell.configCell(email: email, message: message.content)
                    cell.profileImageView.loadImageUsingCacheWithUrlString(returnedImageURL)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

