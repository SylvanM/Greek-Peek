//
//  ViewController.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 3/16/22.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CLLocationManager().requestWhenInUseAuthorization()
        
        self.mapView.delegate = self
        
        gatherRoutes { routes in
            self.mapView.addAnnotations( routes.map { RouteAnnotation(route: $0) } )
            self.mapView.addOverlays( routes.map { RouteOverlay(route: $0) } )
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let greekPeakRegion = MKCoordinateRegion(
            MKMapRect(x: 42.501409,
                      y: 76.139496,
                      width:    abs(42.501409 - 42.509028),
                      height:   abs(76.139496 - 76.153507))
        )
        
        mapView.setRegion(
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.501409, longitude: -76.139496),
                               span: MKCoordinateSpan(
                                latitudeDelta: abs(42.501409 - 42.509028),
                                longitudeDelta: abs(76.139496 - 76.153507)
                              )), animated: false)
        
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: greekPeakRegion), animated: false)
        
        mapView.showsUserLocation = true
        mapView.showsCompass = true
    }
    
    
    // MARK: MapView Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        if let route = annotation as? RouteAnnotation {
            return route.annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let routeOverlay = overlay as? RouteOverlay {
            return RouteOverlayRenderer(overlay: routeOverlay)
        }

        return MKOverlayRenderer(overlay: overlay)
    }
    
    // MARK: Methods
    
    /**
     * Gathers a list of all the available routes
     */
    func gatherRoutes(completion: @escaping ([Route]) -> ()) {
        do {
            try NetworkManager.getAllRoutes { routes in
                completion(routes)
            }
        } catch {
            print("Something terrible happened!")
        }
    }

}


