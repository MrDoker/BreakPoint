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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLabel.text = Auth.auth().currentUser?.email
        DataService.instance.getUserAvatar(forUID: (Auth.auth().currentUser?.uid)!) { (returnedImageURL) in
            self.profileImageView.loadImageUsingCacheWithUrlString(returnedImageURL)
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
        
        DataService.instance.uploadUserAvatar(imageData: image.jpegData(compressionQuality: 0.2)!) { (returnedURL) in
            if returnedURL == nil {
                //TODO: handle error
            }
            DataService.instance.getUserAvatar(forUID: (Auth.auth().currentUser?.uid)!) { (returnedImageURL) in
                self.profileImageView.loadImageUsingCacheWithUrlString(returnedImageURL)
            }
        }
    }
}
