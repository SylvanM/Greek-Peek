//
//  RouteRenderer.swift
//  Greek Peek
//
//  Created by Sylvan Martin on 3/23/22.
//

import Foundation
import MapKit

class RouteAnnotation: NSObject, MKAnnotation {
    
    private let route: Route
    
    init(route: Route) {
        self.route = route
    }
    
    // MARK: Computed Properties
    
    var coordinate: CLLocationCoordinate2D {
        route.generalCoords
    }
    
    var title: String? {
        route.name
    }
    
    var subtitle: String? {
        route.difficulty.asString
    }
    
    // MARK: Annotations and Overlays
    
    var annotationView: MKAnnotationView {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.title = route.name
        pointAnnotation.coordinate = coordinate
        
        let markerView = MKMarkerAnnotationView()
        markerView.annotation = pointAnnotation
        
        return markerView
    }
    
    
    
}

class RouteOverlay: MKPolyline {
    
    let route: Route
    let poly: MKPolyline

    init(route: Route, poly: MKPolyline) {
        self.route = route
        self.poly = poly
    }
    
}

class RouteOverlayRenderer: MKOverlayRenderer {
    
    var routeOverlay: RouteOverlay
    
    init(overlay: MKOverlay, routeOverlay: RouteOverlay) {
        self.routeOverlay = routeOverlay
        super.init(overlay: overlay)
        print("Created Renderer")
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        print("Drawing")
        
        let polylineRenderer = MKPolylineRenderer(polyline: routeOverlay.poly)

        polylineRenderer.strokeColor = routeOverlay.route.difficulty.color
        polylineRenderer.lineWidth = 5
        
        polylineRenderer.draw(mapRect, zoomScale: zoomScale, in: context)
    }
    
}
