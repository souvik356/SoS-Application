//
//  EmergencyContactViewController.swift
//  SoSApp1
//
//  Created by M sai deepthi on 02/08/24.
//

import UIKit
import Contacts
import ContactsUI

class EmergencyContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Emergency Contact List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEmergencyContact))
    }
}

extension EmergencyContactViewController : CNContactPickerDelegate {
    @objc func addEmergencyContact(){
         let contactList = CNContactPickerViewController()
        contactList.delegate = self
        present(contactList,animated: true)
     }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print(contact.givenName,contact.phoneNumbers)
    }
    
}
