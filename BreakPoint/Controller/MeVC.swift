//
//  MeVC.swift
//  BreakPoint
//
//  Created by DokeR on 12.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {
    
    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderForTableView: UILabel!
    
    var feedMessages = [NewMessage]()
    var groupWithMessagesDict = [String: [NewMessage]]()
    var groupsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLabel.text = Auth.auth().currentUser?.email
        DataService.instance.getUserAvatar(forUID: (Auth.auth().currentUser?.uid)!) { (returnedImageURL) in
            self.profileImageView.loadImageUsingCacheWithUrlString(returnedImageURL)
        }
        
        DataService.instance.getAllMessagesForUser { (feedMessages, groupsMessages) in
            self.feedMessages = feedMessages
            self.groupWithMessagesDict = groupsMessages
            
            self.groupsArray.removeAll()
            for key in groupsMessages.keys {
                self.groupsArray.append(key)
            }
            
            self.configUI()
            self.tableView.reloadData()
        }
    }
    
    func configUI() {
        if feedMessages.count == 0 && groupsArray.count == 0 {
            tableView.isHidden = true
            placeholderForTableView.isHidden = false
        } else {
            tableView.isHidden = false
            placeholderForTableView.isHidden = true
        }
    }

    @IBAction func signOutButtonWasPressed(_ sender: Any) {
        let logOutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Logout", style: .destructive) { (_) in
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        logOutAlert.addAction(logOutAction)
        logOutAlert.addAction(cancelAction)
        
        present(logOutAlert, animated: true, completion: nil)
    }
    
    @IBAction func changeImageBtnWasPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension MeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        profileImageView.image = image
        
        DataService.instance.uploadUserAvatar(imageData: image.jpegData(compressionQuality: 0.1)!) { (returnedURL) in
            if returnedURL == nil {
                //TODO: handle error
            }
            DataService.instance.getUserAvatar(forUID: (Auth.auth().currentUser?.uid)!) { (returnedImageURL) in
                self.profileImageView.loadImageUsingCacheWithUrlString(returnedImageURL)
            }
        }
    }
}

extension MeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if feedMessages.count > 0 {
            return groupsArray.count + 1
        } else {
            return groupsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if feedMessages.count == 0 {
            return groupsArray[section]
        } else {
            if section == 0 {
                return "Messages in Feed"
            } else {
                return groupsArray[section - 1]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if feedMessages.count == 0 {
            return groupWithMessagesDict[groupsArray[section]]?.count ?? 0
        } else {
            if section == 0 {
                return feedMessages.count
            } else {
                return groupWithMessagesDict[groupsArray[section - 1]]?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var message = ""
        
        if feedMessages.count == 0 {
            let messageArray = groupWithMessagesDict[groupsArray[indexPath.section]]
            message = messageArray![indexPath.row].content
        } else {
            if indexPath.section == 0 {
                message = feedMessages[indexPath.row].content
            } else {
                let messageArray = groupWithMessagesDict[groupsArray[indexPath.section - 1]]
                message = messageArray![indexPath.row].content
            }
        }
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell") as? MyMessagesCell {
            cell.configCellWith(message)
            return cell
        }
        return MyMessagesCell()
    }
}
