//
//  CreatePostVC.swift
//  BreakPoint
//
//  Created by DokeR on 17.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.delegate = self
        sendButton.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailLabel.text = Auth.auth().currentUser?.email
        DataService.instance.getUserAvatar(forUID: (Auth.auth().currentUser?.uid)!) { (returnedURL) in
            self.profileImageView.loadImageUsingCacheWithUrlString(returnedURL)
        }
    }

    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonWasPressed(_ sender: Any) {
        if messageTextView.text != nil && messageTextView.text != "" &&  messageTextView.text != "//Say something here..." {
            sendButton.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTextView.text, forUID: Auth.auth().currentUser?.uid ?? "1a2b3c", withGroupKey: nil) { (success) in
                if success {
                    self.sendButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    self.sendButton.isEnabled = true
                    print("!!!!Can't send message to Feed!!!!!!!")
                }
            }
        }
    }
    
}

extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageTextView.text = ""
    }
    
}
