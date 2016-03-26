//
//  ViewController.swift
//  Athena
//
//  Created by Abdel Wahab Turkmani on 3/24/16.
//  Copyright © 2016 AJI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var theMap: MKMapView!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var connect: UIButton!
    
    @IBAction func establishConnection(sender: AnyObject) {
    }
    
    // Degine our variables
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup our location manager
        manager = CLLocationManager()
        manager.delegate =  self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        // Setup our Map View
        theMap.delegate = self
        theMap.mapType = MKMapType.Hybrid
        theMap.showsUserLocation = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        status.text = "\(locations[0])"
//        myLocations.append(locations[0] )
        
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap.setRegion(newRegion, animated: true)
        
//        if (myLocations.count > 1){
//            let sourceIndex = myLocations.count - 1
//            let destinationIndex = myLocations.count - 2
        
//            let c1 = myLocations[sourceIndex].coordinate
//            let c2 = myLocations[destinationIndex].coordinate
//            var a = [c1, c2]
//            let polyline = MKPolyline(coordinates: &a, count: a.count)
//            theMap.addOverlay(polyline)
//        }
    }
    
//    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//        
//        if overlay is MKPolyline {
//            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = UIColor.blueColor()
//            polylineRenderer.lineWidth = 4
//            return polylineRenderer
//        }
//        return MKPolylineRenderer()
//    }


}

