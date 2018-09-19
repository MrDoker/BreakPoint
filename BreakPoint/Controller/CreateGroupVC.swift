//
//  CreateGroupVC.swift
//  BreakPoint
//
//  Created by DokeR on 19.09.2018.
//  Copyright © 2018 DokeR. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController {
    
    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailTextField: InsetTextField!
    @IBOutlet weak var groupMembersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.isHidden = true
    }
    
    @IBAction func doneButtonWasPressed(_ sender: Any) {
        
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange() {
        if emailTextField.text == "" {
            emailArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSeachQuery: emailTextField.text!) { (emailArray) in
                self.emailArray = emailArray
                self.tableView.reloadData()
            }
        }
    }
}

extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserTableViewCell {
            let image = UIImage(named: "defaultProfileImage")
            if chosenUserArray.contains(emailArray[indexPath.row]) {
                cell.configCell(profileImage: image!, email: emailArray[indexPath.row], isSelected: true)
            } else {
                cell.configCell(profileImage: image!, email: emailArray[indexPath.row], isSelected: false)
            }
            
            
            return cell
        }
        return UserTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell else { return }
        if !chosenUserArray.contains(cell.emailLabel.text!) {
            chosenUserArray.append(cell.emailLabel.text!)
            groupMembersLabel.text = chosenUserArray.joined(separator: ", ")
            doneButton.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLabel.text! })
            if chosenUserArray.isEmpty {
                groupMembersLabel.text = "add people to your group"
                doneButton.isHidden = true
            } else {
                groupMembersLabel.text = chosenUserArray.joined(separator: ", ")
            }
        }
    }
}

extension CreateGroupVC: UITextFieldDelegate {
    
}









