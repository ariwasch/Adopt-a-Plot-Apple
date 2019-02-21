//
//  createView.swift
//  Adopt-A-Plot
//
//  Created by Ari Wasch on 12/1/18.
//  Copyright © 2018 Ari Wasch. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class createView: UIViewController, NSURLConnectionDataDelegate, MKMapViewDelegate{
    static public var isCostum = false
    static public var noPlot = true
    let regionMeters: Double = 1000
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    var listLat = [Double]()
    var listLong = [Double]()
    @IBOutlet weak var txtField: UITextView!
    @IBOutlet weak var enter: UIButton!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var textBox: UITextField!
    public static var locations: [CLLocation] = []
    var locationRegion: [CLLocation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()

        addAnnotations2()
        
    }
    override func viewDidAppear(_ animated: Bool) {

        if let lat = defaults.array(forKey: "lat"){
            listLat = lat as! [Double]
        }
        if let long = defaults.array(forKey: "long"){
            listLong = long as! [Double]
        }
        createView.locations = []
        for i in 0 ..< listLat.count{
            
            createView.locations.append(CLLocation(latitude: listLat[i], longitude: listLong[i]))
            txtField.text.append("\(String(listLat[i]) + ", " + String(listLong[i]))\n")
        }
        if defaults.bool(forKey: "costum"){
            createView.isCostum = defaults.bool(forKey: "costum")
        }
        addAnnotations2()
        if(createView.locations.count <= 0){
            createView.noPlot = true
        }else{
            createView.noPlot = false
        }
    }
    func updateCustom() -> [CLLocation]{
        if let lat = defaults.array(forKey: "lat"){
            listLat = lat as! [Double]
        }
        if let long = defaults.array(forKey: "long"){
            listLong = long as! [Double]
        }
        createView.locations = []
        for i in 0 ..< listLat.count{
            
            createView.locations.append(CLLocation(latitude: listLat[i], longitude: listLong[i]))
        }
        return createView.locations
    }
    @IBAction func remove(sender: UIButton){
        if(createView.locations.count > 0){
            createView.locations.remove(at: createView.locations.count-1)
            
            txtField.text.removeAll()
            for i in 0 ..< createView.locations.count{
            txtField.text.append("\(String(createView.locations[i].coordinate.latitude) + ", " + String(createView.locations[i].coordinate.longitude))\n")
            }
            
        }
        if(listLong.count > 0){
            listLong.remove(at: listLong.count-1)
            listLat.remove(at: listLat.count-1)
        }
         map.removeOverlays(map.overlays)
         addAnnotations2()
    }
    @IBAction func clear(sender: UIButton){
        createView.locations = []
        listLong = []
        listLat = []
        txtField.text.removeAll()
        map.removeOverlays(map.overlays)
    }
    @IBAction func tap(sender: UIButton){
        if let text = textBox.text{
            if text == ""{
                return
            }
            if text.contains(","){
            let array = text.components(separatedBy: ",")
                let lat = array[0]
                let long = array[1]
                if(Double(lat) != nil && Double(long) != nil){
//                    if(lat < 100 && long < 100){
                    txtField.text.append("\(lat + "," + long)\n")
                createView.locations.append(CLLocation(latitude: Double(lat)!, longitude: Double(long)!))
                locationRegion.append(CLLocation(latitude: Double(lat)!, longitude: Double(long)!))
                    textBox.text = ""
                        
//                }
            textBox.resignFirstResponder()
                
            }
            addAnnotations2()
        }
        saveLocations()
    }
    }
    func updateTruth() -> Bool{
        if defaults.bool(forKey: "costum"){
            createView.isCostum = defaults.bool(forKey: "costum")
        }
            return createView.isCostum
    }
    @IBAction func save(sender: UIButton){
        createView.isCostum = true
        saveLocations()
        let b = createView.isCostum
        UserDefaults.standard.set(listLat, forKey: "lat")
        UserDefaults.standard.set(listLong, forKey: "long")
        UserDefaults.standard.set(b, forKey: "costum")
        
        
    }
    func removeMapOverlay() {
        let overlays = map.overlays
        map.removeOverlays(overlays)
    }
    func saveLocations(){
        listLat = []
        listLong = []
        for i in 0 ..< createView.locations.count {
            listLat.append(createView.locations[i].coordinate.latitude)
            listLong.append(createView.locations[i].coordinate.longitude)
        }
    }
    func addAnnotations2(){
        removeMapOverlay()
        if(createView.locations.count > 0){
            print(createView.locations.count)
            map?.delegate = self
            var lat1:Double = 0
            var long1:Double = 0
            if(locationRegion.count > 0){
                for i in 0...locationRegion.count-1{
                    lat1 += locationRegion[i].coordinate.latitude
                    long1 += locationRegion[i].coordinate.longitude
                }
            
                lat1 = lat1/Double(createView.locations.count)
                long1 = long1/Double(createView.locations.count)
                let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                let polyRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationRegion[locationRegion.count-1].coordinate.latitude, longitude: locationRegion[locationRegion.count-1].coordinate.longitude), span: span)
                map.setRegion(polyRegion, animated:true)
            }
                var realCoords = createView.locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
                var realPoly = MKPolyline(coordinates: &realCoords, count: createView.locations.count)

                
            
            self.map.addOverlay(realPoly)
            
        }
        
    }
    func addAnnotations(){
        //angler()
        removeMapOverlay()
        if(createView.locations.count > 0){
            print(createView.locations.count)
        map?.delegate = self
//        let testCoordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
            
        var lat1:Double = 0
        var long1:Double = 0
            if(locationRegion.count > 1){
        for i in 0...locationRegion.count-1{
            lat1 += locationRegion[i].coordinate.latitude
            long1 += locationRegion[i].coordinate.longitude
        }
            }
            lat1 = lat1/Double(createView.locations.count)
            long1 = long1/Double(createView.locations.count)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let polyRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat1, longitude: long1), span: span)
        
//            var testPoly = MKPolyline(coordinates: createView.locations, count: createView.locations.count)
            var locationConvert: [CLLocation] = []
            for i in 0..<createView.locations.count{
                locationConvert.append(CLLocation(latitude: createView.locations[i].coordinate.latitude, longitude: createView.locations[i].coordinate.longitude))
            }
            var testCoordinates = locationConvert.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
            var realCoords = createView.locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
            var actDist: Double = 10000000
            var testPoly = MKPolygon(coordinates: &testCoordinates, count: createView.locations.count)
             var realPoly = MKPolyline(coordinates: &realCoords, count: createView.locations.count)
            let polygon = MKPolygon(coordinates: testCoordinates, count: testCoordinates.count)
            ViewController.returnPoly = polygon
            
            for i in 0...createView.locations.count-1{
                for j in 0...createView.locations.count-1{
                    if(i > 0 && j > 0){
                        var totDist: Double = 0
                        createView.locations.swapAt(i, j)
                        for x in 1...createView.locations.count-1{
                            totDist += createView.locations[x-1].distance(from: createView.locations[x])
                        }
                        if totDist < actDist{
                            print(createView.locations.count)
                            actDist = totDist
                            testCoordinates = createView.locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
                            testPoly = MKPolygon(coordinates: &testCoordinates, count: createView.locations.count)
                            print(totDist)
                            print(actDist)
                        }
                    }
                }
            }
            
//        map.setRegion(polyRegion, animated:true)
            
            
//        map?.addOverlay(polygon)
//            self.map.addOverlay(testPoly)

//            if(createView.locations.count > 0){
//            for i in 0..<listLat.count-1{
//                var adj = 0.0
//                var opp = 0.0
//                var angle = 0.0
//                adj = listLat[i] + lat1
//                opp = listLong[i] + long1
////                adj = listLat[i]
////                opp = listLong[i]
//                angle = atan(opp/adj)
//                angles.append(angle)
//                print(angle)
//            }
//            angles = selectionSort(angles)
//            for i in 0..<angles.count-1{
//                for j in i..<listLat.count-1{
//                    if atan((abs(listLong[j] + abs(long1)))/(abs(listLat[i]) + abs(lat1))) == angles[i]{
//                        newLat.append(listLat[j])
//                        newLong.append(listLong[j])
//                    }
//                }
//            }
//            }
            self.map.addOverlay(realPoly)
            
//            self.map.addOverlay(polygon)
//            self.map.addOverlay(testPoly)
//            var idk = mapKit.PolygonOverlay(locations[])
            
            
//            MKPolygon * thePoly = [MKPolygon, polygonWithCoordinates: polygon count:polygon.count];
            //self.map.addOverlay(thePoly)
        }
    }
//    func angler(){
//        if(createView.locations.count > 0){
//        for i in 0 ..< createView.locations.count {
//            listLat.append(createView.locations[i].coordinate.latitude)
//            listLong.append(createView.locations[i].coordinate.longitude)
//        }
//        }
//
//        var angles = [Double]()
//        var angles1 = [Double]()
//        var angles2 = [Double]()
//        var angles3 = [Double]()
//        var angles4 = [Double]()
//        for i in 0 ..< createView.locations.count {
//            listLat.append(createView.locations[i].coordinate.latitude)
//            listLong.append(createView.locations[i].coordinate.longitude)
//        }
//        if(listLat.count > 0){
//        for i in 0..<listLat.count-1{
//            if(listLat[i] > 0 && listLong[i] > 0){
//                angles1.append(listLong[i]/listLat[i])
//                angles1 = selectionSort(angles1)
//            }else if(listLat[i] > 0 && listLong[i] < 0){
//                angles2.append(listLong[i]/listLat[i])
//                angles2 = selectionSort(angles2)
//            }else if(listLat[i] < 0 && listLong[i] < 0){
//                angles3.append(listLong[i]/listLat[i])
//                angles3 = selectionSort(angles3)
//            }else if(listLat[i] < 0 && listLong[i] > 0){
//                angles4.append(listLong[i]/listLat[i])
//                angles4 = selectionSort(angles4)
//            }
//            print(listLong[i]/listLat[i])
//        }
//
//        if(angles1.count > 0){
//            for j in 0..<angles1.count{
//                angles.append(angles1[j])
//            }
//        }
//        if(angles2.count > 0){
//            for j in 0..<angles2.count{
//                angles.append(angles2[j])
//            }
//        }
//        if(angles3.count > 0){
//            for j in 0..<angles3.count{
//                angles.append(angles3[j])
//            }
//        }
//        if(angles4.count > 0){
//            for j in 0..<angles4.count{
//                angles.append(angles4[j])
//            }
//        }
//            var newLat = [Double]()
//            var newLong = [Double]()
//        for i in 0..<createView.locations.count-1{
//            if(listLat.count > 0){
//            for j in i..<createView.locations.count-1{
//                if(listLat.count > 0){
//                if listLong[j]/listLat[j] == angles[i]{
//                    newLat.append(listLat[j])
//                    newLong.append(listLong[j])
//                    listLong.remove(at: j)
//                    listLat.remove(at: j)
//                    angles.remove(at: i)
//                    }
//                }
//            }
//            }
//        }
//        listLat = newLat
//        listLong = newLong
//
//            print(newLat.count)
//            if(listLat.count > 0){
//                //createView.locations = []
//        for i in 0..<listLat.count-1{
//            createView.locations.append(CLLocation(latitude: listLat[i], longitude: listLong[i]))
//            print("n")
//            print(listLat[i], ", ", listLong[i])
//            print("0")
//        }
//            }
//        }
//        print("hi")
//    }
//    func selectionSort(_ array: [Double]) -> [Double] {
//        guard array.count > 1 else { return array }
//
//        var arr = array
//
//        for x in 0 ..< arr.count - 1 {
//            var lowest = x
//            for y in x + 1 ..< arr.count {
//                if arr[y] < arr[lowest] {
//                    lowest = y
//                }
//            }
//            if x != lowest {
//                arr.swapAt(x, lowest)
//            }
//        }
//        return arr
//    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
            
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 2
            return renderer
            
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            //renderer.fillColor = UIColor.blue.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 2
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func setUpLocationManager(){
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
        addAnnotations2()
    }
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            map.setRegion(region, animated:true)
        }
    }
    func checkLocationServices(){
        if(CLLocationManager.locationServicesEnabled()){
            setUpLocationManager()
            checkLocationAuthorization()
        }else{
            
        }
    }
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            map.showsUserLocation = true
//            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            let alert = UIAlertController(title: "Location Permissions", message: "Location permissions must be turned on in settings to see your location relative to your plot.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            break
        case .restricted:
            let alert = UIAlertController(title: "Location Permissions", message: "Location access is restricted on this device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            break
        case .authorizedAlways:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        }
    }
}
