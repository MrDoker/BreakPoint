//
//  GroupFeedVC.swift
//  BreakPoint
//
//  Created by DokeR on 20.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var sendTextField: InsetTextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendViewBottomConstraint: NSLayoutConstraint!
    
    
    var group: Group?
    var groupMessages = [NewMessage]()
    
    func initDataForGroup(_ group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(tap)
        tableView.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipe.direction = .right
        tableView.addGestureRecognizer(swipe)
    }
    
    @objc func tapHandler() {
        sendTextField.resignFirstResponder()
    }
    
    @objc func swipeHandler() {
        dismissDetail()
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            sendViewBottomConstraint.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            
            UIView.animate(withDuration: 0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLabel.text = group?.groupTtile
        
        DataService.instance.getEmailsForGroup(group!) { (returnedEmailsArray) in
            self.membersLabel.text = returnedEmailsArray.joined(separator: ", ")
        }
        
        DataService.instance.refGroups.observe(.value) { (_) in
            DataService.instance.getAllMessagesFor(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.groupMessages.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func sendButtonWasPressed(_ sender: Any) {
        if sendTextField.text != "" {
            sendTextField.isEnabled = false
            sendButton.isEnabled = false
            
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = "yyyy, MMM d, HH:mm:ss"
            let sendDate = newFormatter.string(from: Date())
            
            DataService.instance.uploadPost(withMessage: sendTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key, sendDate: sendDate) { (success) in
                self.sendTextField.isEnabled = true
                self.sendTextField.text = ""
                self.sendButton.isEnabled = true
            }
        }
    }
    
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupFeedCell") as? GroupFeedCell else { return GroupFeedCell() }
        
        let message = groupMessages[indexPath.row]
        
        cell.configCell(profileImageURL: message.senderImageURL, email: message.senderEmail, content: message.content, sendDate: message.sendDate)
        return cell
    }
    
    
}





