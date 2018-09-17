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

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.delegate = self
        sendButton.bindToKeyboard()
    }
    

    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonWasPressed(_ sender: Any) {
        if messageTextView.text != nil && messageTextView.text != "" &&  messageTextView.text != "//Say something here..." {
            sendButton.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTextView.text, forUID: Auth.auth().currentUser?.uid ?? "1a2b3c", withGroupLEy: nil) { (success) in
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
