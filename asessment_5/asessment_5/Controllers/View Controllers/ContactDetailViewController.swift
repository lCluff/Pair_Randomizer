//
//  ContactDetailViewController.swift
//  asessment_5
//
//  Created by Leah Cluff on 7/12/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var contact: Contact?
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
        let email = emailTextField.text, !email.isEmpty,
        let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty
        else {return}
        if let contact = contact {
            ContactController.sharedInstance.updateContact(contact: contact, withName: name, email: email, phoneNumber: phoneNumber)
        } else {
            ContactController.sharedInstance.createContacts(name: name, email: email, phoneNumber: phoneNumber)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
