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
            self.mapView.addOverlays( routes.map { RouteOverlay(route: $0, poly: MKPolyline(coordinates: $0.pathCoords, count: $0.pathCoords.count)) } )
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
            return RouteOverlayRenderer(overlay: overlay, routeOverlay: routeOverlay)
        }

        return MKOverlayRenderer(overlay: overlay)
    }
    
    // MARK: Methods
    
    /**
     * Gathers a list of all the available routes
     */
    func gatherRoutes(completion: @escaping ([Route]) -> ()) {
        completion(allRoutes)
    }

}

let allRoutes = [
    Route(
        name: "East Meadows",
        latitude: 42.502848, longitude: -76.148683,
        difficulty: .green,
        pathCoords: [
            CLLocationCoordinate2D(latitude: 42.502358, longitude: -76.150309),
            CLLocationCoordinate2D(latitude: 42.502620, longitude: -76.146984),
            CLLocationCoordinate2D(latitude: 42.503706, longitude: -76.145122)
        ]
    ),
    
    Route(
        name: "Odyssey",
        latitude: 42.505393, longitude: -76.150207,
        difficulty: .black,
        pathCoords: []
    ),
    
    Route(
        name: "Trojan",
        latitude: 42.497478, longitude: -76.145435,
        difficulty: .blue,
        pathCoords: []
    )
    
]
