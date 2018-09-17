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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DataService.instance.getAllFeedMessages { (messages) in
            self.messagesArray = messages
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
            let image = UIImage(named: "defaultProfileImage")
            let message = messagesArray[indexPath.row]
            
            cell.configCell(profileImage: image ?? UIImage(), email: message.senderId, message: message.content)
            return cell
        }
        return UITableViewCell()
    }
    
    
}

