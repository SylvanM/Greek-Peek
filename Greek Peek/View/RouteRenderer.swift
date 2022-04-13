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

class RouteOverlay: NSObject, MKOverlay {
    
    let route: Route
    
    var coordinate: CLLocationCoordinate2D {
        route.generalCoords
    }
    
    var boundingMapRect: MKMapRect {
        MKPolyline(coordinates: route.pathCoords, count: route.pathCoords.count).boundingMapRect
    }

    init(route: Route) {
        self.route = route
    }
    
}

class RouteOverlayRenderer: MKOverlayRenderer {
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        
        if let route = (overlay as? RouteOverlay)?.route {
            let polyline = MKPolyline(coordinates: route.pathCoords, count: route.pathCoords.count)
            let polyRend = MKPolylineRenderer(polyline: polyline)
            
            polyRend.strokeColor = route.difficulty.color
            polyRend.lineWidth = 5
            
            polyRend.draw(mapRect, zoomScale: zoomScale, in: context)
            return
        }
        
        super.draw(mapRect, zoomScale: zoomScale, in: context)
        
    }
        
}
