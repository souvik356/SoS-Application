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
    @IBOutlet weak var tableView: UITableView!
    
    var contacts = [ContactPerson]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Emergency Contact List"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEmergencyContact))
        loadContacts()
        tableView.reloadData()
    }
}

extension EmergencyContactViewController : CNContactPickerDelegate {
    @objc func addEmergencyContact(){
         let contactList = CNContactPickerViewController()
        contactList.delegate = self
        present(contactList,animated: true)
     }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = "\(contact.givenName)  \(contact.familyName)"
        print("Array:- \(contact.phoneNumbers)")
        var phoneNumbers: [String] = []
        for phoneNumber in contact.phoneNumbers {
            let number = phoneNumber.value.stringValue
            phoneNumbers.append(number)
        }
        let contactName = ContactPerson(id: contact.identifier, name: name, contact: phoneNumbers)
        contacts.append(contactName)
        saveContact()
        tableView.reloadData()
    }
}

extension EmergencyContactViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contactData = contacts[indexPath.row]
        cell.textLabel?.text = contactData.name
        cell.detailTextLabel?.text = contactData.contact.joined(separator: ",")
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            contacts.remove(at: indexPath.row)
            saveContact()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // implementing userDefualts so that I can store my emergency contact in my device
    // implement swiftData
    // key chain , plist , swiftData , coreData , userDefault
    
    func saveContact(){
        if let encoded = try? JSONEncoder().encode(contacts){
            UserDefaults.standard.setValue(encoded, forKey: "contacts")
        }
    }
    
    func loadContacts(){
        if let saveContactData = UserDefaults.standard.data(forKey: "contacts"){
            if let decodedData = try? JSONDecoder().decode([ContactPerson].self, from: saveContactData){
                contacts = decodedData
            }
        }
    }
}
