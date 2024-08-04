//
//  ViewController.swift
//  SoSApp1
//
//  Created by M sai deepthi on 02/08/24.
//

import UIKit
import CoreLocation

class SosViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contactListBtn: UIButton!
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "SOS App"
        contactListBtn.layer.cornerRadius = 15
        contactListBtn.clipsToBounds = true
        locationManager.delegate = self  // here i am providing locationManager delegate to my class SosViewController
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func sosBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func contactListButton(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactListVc = storyboard.instantiateViewController(withIdentifier: "EmergencyContactViewController") as! EmergencyContactViewController
        navigationController?.pushViewController(contactListVc, animated: true)
    }
    
}

extension SosViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty{
            if let location = locations.first {
//                print(location.coordinate.latitude, location.coordinate.longitude)
                geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let placemark = placemarks?.first {
                        self.locationLabel.text = "\(placemark.subLocality ?? "") \(placemark.locality ?? "") \(placemark.postalCode ?? "")"
                    }
                }
            }
        }
    }
}

