//
//  ViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 03/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let vk: SwiftyVKDelegate = SwiftyVKDelegate()
    @IBOutlet weak var map: MKMapView!
    private var locationManager: CLLocationManager!
    var coords: (Double, Double) = (0, 0)
    let vkManager = ApiWorker.sharedInstance
    var friends = [VKFriendClass]()
    
    private var geocoder = CLGeocoder()
    
    override func loadView() {
        super.loadView()
        vkManager.friendsGet()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.reloadMap()
            self.setRegionAndSpan()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.reloadMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func reloadMap(){
        map.removeAnnotations(map.annotations)
        self.friends = self.vkManager.friends
        self.addFriendsOnMap()
    }
    
    
    func addFriendsOnMap(){
        for friend in friends{
            addFriendOnMap(friend: friend)
        }
    }
    
    func addFriendOnMap(friend: VKFriendClass){
        if(friend.coordinate.longitude == 0 && friend.coordinate.latitude == 0){
            return
        }
        friend.coordinate.latitude += MapViewController.randomDouble(min: -0.1, max: 0.1)
        friend.coordinate.longitude += MapViewController.randomDouble(min: -0.1, max: 0.1)
        map.addAnnotation(friend)
        
    }
    
    internal func locationManager(_ manager: CLLocationManager,
                                  didFailWithError error: Error) {
        print("error: ", error)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coords = (locations[0].coordinate.latitude, locations[0].coordinate.longitude)
        if let location = locations.first {
            let span = MKCoordinateSpanMake(100, 100)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            map.setRegion(region, animated: true)
        }
        locationManager.stopUpdatingLocation()
        addLastLocation()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? VKFriendClass {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                if let imageView = dequeuedView.leftCalloutAccessoryView as? UIImageView{
                    if annotation.getLinkPhoto() == ""{
                        imageView.image = #imageLiteral(resourceName: "camera")
                    }
                    else{
                        imageView.sd_setImage(with: URL(string: annotation.getLinkPhoto()))
                    }
                }
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation,
                                           reuseIdentifier: identifier)
                view.isEnabled = true
                view.canShowCallout = true
                let btn = UIButton(type: .detailDisclosure)
                view.rightCalloutAccessoryView = btn
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                if annotation.getLinkPhoto() == ""{
                    imageView.image = #imageLiteral(resourceName: "camera")
                }else{
                    imageView.sd_setImage(with: URL(string: annotation.getLinkPhoto())) //= annotation.profileImage.image
                }
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 20
                view.leftCalloutAccessoryView = imageView as UIView
            }
            return view
        }
        return nil
    }
    
    
    internal func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView){
        if view.annotation is MKUserLocation{
            return
        }
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       performSegue(withIdentifier: "fromMapSegue", sender: view)
    }
    
    
    
    func setRegionAndSpan(){
        map.showAnnotations(map.annotations, animated: true)
    }
    
}


extension MapViewController{
    static func randomDouble(min: Double, max: Double) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
}

// MARK: - prepare for segue
extension MapViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromMapSegue"{
            if let annotationView = sender as? MKAnnotationView{
                let friend = annotationView.annotation as! VKFriendClass
                let vc = segue.destination as! PersonInformationViewController
                vc.name = friend.getName()
                vc.city = friend.getCity()
                vc.id = friend.getId()
                vc.ProfileImage = friend.profileImage.image
            }
        }
    }
}



extension MapViewController{
    func addLastLocation(){
        let realm = try! Realm()
        try! realm.write{
            let user = User()
            user.latidute = self.coords.0
            user.longitude = self.coords.1
            user.created = Date()
            realm.add(user)
        }
    }
    
    func getUsers() -> Results<User>{
        let users = try! Realm().objects(User.self)
        return users
    }
}
