//
//  ViewController.swift
//  SoSApp1
//
//  Created by M sai deepthi on 02/08/24.
//

import UIKit
import CoreLocation
import MessageUI


class SosViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "SOS App"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        loader.startAnimating()
        self.locationAcsess()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(contactList))
    }
    
    private func locationAcsess() {
        locationManager.delegate = self  // here i am providing locationManager delegate to my class SosViewController
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func sendLocationMessage(message: String) {
        var contacts = [ContactPerson]()
        
        if let saveContacts = UserDefaults.standard.data(forKey: "contacts") {
            if let decodedContacts = try? JSONDecoder().decode([ContactPerson].self, from: saveContacts) {
                contacts = decodedContacts
            }
        }
        
        let phoneNumber = contacts.flatMap {$0.contact}
        
        if(MFMessageComposeViewController.canSendText()) {
            let messageVc = MFMessageComposeViewController()
            messageVc.body = message
            messageVc.recipients = phoneNumber
            messageVc.messageComposeDelegate = self
            self.present(messageVc, animated: true, completion: nil)
        }
        else {
            print("SMS function is not available")
        }
    }

    @IBAction func sosBtnPressed(_ sender: Any) {
        if let location = locationLabel.text , !location.isEmpty , location != "Error updating location" {
            let sosMessage = "I need help..!! This is my address:- \(location)"
            self.sendLocationMessage(message: sosMessage)
        }
        else{
            print("location not available please wait")
        }
    }
    
    @objc func contactList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactListVc = storyboard.instantiateViewController(identifier: "EmergencyContactViewController") as! EmergencyContactViewController
        navigationController?.pushViewController(contactListVc, animated: true)
    }
    
}

extension SosViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty{
            if let location = locations.first {
                geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                    if error != nil{
                        print("Error updating location")
                        self.locationLabel.text = "Error updating location"
                        self.loader.stopAnimating()
                        self.loader.hidesWhenStopped = true
                        return
                    }
                    if let placemark = placemarks?.first{                        
                        self.locationLabel.text = "\(placemark.subLocality ?? "") \(placemark.locality ?? "") \(placemark.postalCode ?? "")"
                        let address = "\(placemark.subLocality ?? "") \(placemark.locality ?? "") \(placemark.postalCode ?? "")"
                        print("I need help..!! This is my address:- \(address)")
                        self.loader.stopAnimating()
                        self.loader.hidesWhenStopped = true
                    }
                }
            }
        }
        locationManager.stopUpdatingLocation()
    }
}

extension SosViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case.cancelled:
            print("Message is cancelled")
        case.failed:
            print("Message sending is failed")
        case.sent:
            print("Message is sent")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

