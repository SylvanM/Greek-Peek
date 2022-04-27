//
//  ViewController.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 3/16/22.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate, RouteManagerDelegate {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var routes: [Route] = [] {
        didSet {
            DispatchQueue.main.async { [self] in
                self.mapView.addAnnotations( routes.map { RouteAnnotation(route: $0) } )
                self.mapView.addOverlays( routes.map { RouteOverlay(route: $0) } )
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        RouteManager.addDelegate(self)
        
        CLLocationManager().requestWhenInUseAuthorization()
        
        gatherRoutes { self.routes = $0 }
        
        self.mapView.delegate = self
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
        mapView.showsCompass = false
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
    
    // MARK: Segue Handlers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let routesVC = segue.destination as? RouteListViewController {
            routesVC.routes = routes
        }
    }
    
    // MARK: Route Loading
    
    func routesReloaded() {
        print("Loaded new routes")
        routes = RouteManager.allRoutes
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
        } catch Route.RouteError.jsonDecodingError(let e) {
            print("Decoding error:", e)
        } catch {
            print("Some other error occured")
        }
    }

}


