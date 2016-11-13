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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let vk: SwiftyVKDelegate = SwiftyVKDelegate()
    @IBOutlet weak var map: MKMapView!
    private var locationManager: CLLocationManager!
    private var coords: (Double, Double) = (0, 0)
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
        if vkManager.state == .authorized {
            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.reloadFriends()
            }
            
        }
        
    }
    
    private func reloadFriends(){
        self.friends = vkManager.friends
        for friend in self.friends{
            let point = CustomAnnotaionClass(coordinate: friend.coordinates)
            point.title = friend.getName()
            map.addAnnotation(point)
        }
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
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        let identifier = "Pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = #imageLiteral(resourceName: "camera")
        return annotationView
    }
    
    
    


    internal func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation{
            return
        }
        
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        performSegue(withIdentifier: "fromMapSegue", sender: view)
    }
    
    
    
}


// MARK: - prepare for segue
extension MapViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromMapSegue"{
                if let vc = segue.destination as? PersonInformationViewController{
                        /*let friend = self.lastFriend
                        vc.title = friend?.getName()
                        vc.city = friend?.getCity()
                        vc.name = friend?.getName()
                        vc.id = friend?.getId()
                        vc.ProfileImage = friend?.profileImage.image*/
            }
        }
    }
}

///todo:

//vkdidautorize
//some event happend(i got frendlist, locations of friends)
//custom cell

