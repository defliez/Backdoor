//
//  GameViewController.swift
//  backdoor
//
//  Created by Valentino on 2023-08-09.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreLocation
import Mapbox


class GameViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    // Properties
    var didShowAlertForSpecialLocation = false
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the Mapbox map
        let mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        
        //special location
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 55.59916667065213, longitude: 13.008512907738607)
        annotation.title = "two geniuses"
        mapView.addAnnotation(annotation)
        
        // locationManager setup
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let specialLocation = CLLocationCoordinate2D(latitude: 55.59916667065213, longitude: 13.008512907738607)
        let distanceToSpecialLocation = location.distance(from: CLLocation(latitude: specialLocation.latitude, longitude: specialLocation.longitude))
        
        if distanceToSpecialLocation < 50.0 {
                // If the user is within the vicinity of the special location and the alert has not been shown yet
                if !didShowAlertForSpecialLocation {
                    // Show the alert
                    let alert = UIAlertController(title: "Special Location", message: "You've reached a special location!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)

                    // Set the flag to true so the alert won't be shown again unless the user leaves and comes back
                    didShowAlertForSpecialLocation = true
                }
            } else {
                // If the user is not in the vicinity, reset the flag so the alert can be shown again next time they enter
                didShowAlertForSpecialLocation = false
            }
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }

    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        return nil
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
