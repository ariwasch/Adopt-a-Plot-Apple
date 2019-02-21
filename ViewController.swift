//
//  ViewController.swift
//  Adopt-A-Plot
//
//  Created by Ari Wasch on 11/2/18.
//  Copyright © 2018 Ari Wasch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController, NSURLConnectionDataDelegate, MKMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    public static var returnPoly: MKPolygon? = nil
    public static var plotNumber = ""
    var notStupid = MorePlots()

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var truth = createView()
    //change below to  1000
    let regionMeters: Double = 1000
//    var coord: [Coord] = [Coord]()
//    var colors: [String] = [String]()
    let coord = Coord.getCoords()
    let number: [String] = [String]()
    var n: Int = 0
    var plotNum = [Int]()
    var selected = ""
    var delete = false
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        

        checkLocationServices()
        addAnnotations()
        
        for i in 1...109{
            plotNum.append(i)
        }
        plotNum.remove(at: 58)
        plotNum.remove(at: 20)
        //remove until they are right
//        plotNum.remove(at: 97)//plot 100
//        plotNum.remove(at: 95)//plot 98
        plotNum.remove(at: 83)//plot 86
        plotNum.remove(at: 70)//plot 73
        plotNum.remove(at: 69)//plot 72

        
        if let orges = defaults.string(forKey: "plot"){
            ViewController.plotNumber = orges
        }
        if let orge = defaults.string(forKey: "select"){
            selected = orge
        }
    }
    
    @IBAction func select(sender: UIButton){
        ViewController.plotNumber = selected
    UserDefaults.standard.set(ViewController.plotNumber, forKey: "plot")
    UserDefaults.standard.set(selected, forKey: "select")
        createView.isCostum = false
        UserDefaults.standard.set(false, forKey: "costum")

        //truth.updateCustom()
    }
    func updatePlotNum() -> String{
        var temp = ""
        if let orges = defaults.string(forKey: "plot"){
            temp = orges
        }
        return temp
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return coord.count
        return plotNum.count
        //CHANGE LATER
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        //delete = true
        var result = ""
        if(plotNum[row] == 1){
            result = "one"
        }else
        if(plotNum[row] < 10){
            result = "00" + String(plotNum[row])
        }else
        if(plotNum[row] == 10){
            result = "ten"
        }else
        {
            result = String(plotNum[row])
        }
        selected = result
        ViewController.plotNumber = result
        removeMapOverlay()
        addAnnotations()
        
        
        //remove annotation before changing it.
        
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = plotNum[row]
        let myTitle = NSAttributedString(string: String(titleData), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return myTitle
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(plotNum[row])
        
    }
    
    
    
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated:true)
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
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
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
    func createPicker(){
        let picker = UIPickerView()
        picker.delegate = self
    }
}
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
        addAnnotations()
        }
    func exists() -> Bool{
        var result = false;
        for item in coord{
            if item.getInfo()!.contains(selected){
                result = true;
            }
        }
        return result
    }
    func addAnnotations() {
//        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.939096,76.469124)
//        var coordinate2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.938291,76.470182)
        mapView?.delegate = self
        
        
//        let coord = Coord.getCoords()
//
//        //var locations: [CLLocationCoordinate2D] = []
//        if coord.getInfo().index(ofAccessibilityElement: 23) >= 1,{
//
//        }
        //var location: [CLLocation] = []
        var locations: [CLLocation] = []
        var tempLocations: [CLLocation] = []
        var locationLat: [Double] = []
        var string = "80"
        var bool = false
        if exists(){
            string = selected
            print("it worked?")
        }else{
            print("Not working")
        }
        print("80")
        //for item in coord{
        
        //}
        print(coord.count)
        for item in coord{
            print(string)
            bool = item.getInfo()!.contains(string)
            //print(item.getInfo())
            //print(bool)
            print(bool)

            if bool{
                //print(bool)
                 locations.append(CLLocation(latitude: item.getLatitude(), longitude: item.getLongitude()))
                print(item.getLatitude(), " ", item.getLongitude())
//                print("lat: ", item.getLatitude())
//                print("long: ", item.getLongitude())
                locationLat.append(item.getLatitude())
                print(item.getInfo())
                print(string)
                print(item.getInfo()!.contains(string))
            }
        }
        //using tallest to shortest
//        locationLat = selectionSort(locationLat)
//        for i in 0...locations.count-1{
//        for j in i...locations.count-1{
//            if coord[i].getLatitude() == locationLat[j]{
//                tempLocations.append(CLLocation(latitude: coord[i].getLatitude(), longitude: coord[i].getLongitude()))
//            }
//        }
//        }
//        locations = removeDuplicates(array: tempLocations)
        //ends here
//
//        var distList: [Double] = []
//        for i in 0...locations.count-1{
//            for j in 0...locations.count-1{
//
//            distList.append(locations[i].distance(from: locations[j]))
//            }
//        }
//        distList = removeDuplicatesD(array: distList)
//        distList = selectionSort(distList)
//        for i in 0...distList.count-1{
//            for j in i...distList.count-1{
//                if locations[i].distance(from: locations[j]) == distList[i]{
//                    locations.append(locations[i])
//                    locations.append(locations[j])
//                   // distList.remove(at: i)
//                }
//            }
//        }
//        locations = removeDuplicates(array: locations)
//
        
//       var locations = [CLLocation(latitude: 38.939096, longitude: -76.469124), CLLocation(latitude: 38.938694,longitude: -76.469653), CLLocation(latitude: 38.938282, longitude: -76.469181)]
        //mapView?.addAnnotations(locations as! [MKAnnotation])
        
        var testCoordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
        var actDist: Double = 10000000
        var testPoly = MKPolyline(coordinates: &testCoordinates, count: locations.count)
        // this works
        //ONLY BAYRIDGE
//        if notStupid.updateOrg().contains("Bay Ridge") && !(selected.elementsEqual("38") || selected.elementsEqual("70") ||
//        selected.elementsEqual("86") || selected.elementsEqual("87")||selected.elementsEqual("92") || selected.elementsEqual("98") || selected.elementsEqual("101") || selected.elementsEqual("103") || selected.elementsEqual("106") || selected.elementsEqual("109")){
        if !(selected.elementsEqual("38") || selected.elementsEqual("70") || selected.elementsEqual("49") ||
            selected.elementsEqual("86") || selected.elementsEqual("87")||selected.elementsEqual("92") || selected.elementsEqual("98") || selected.elementsEqual("100") || selected.elementsEqual("103") || selected.elementsEqual("106") || selected.elementsEqual("109")){
        for i in 0...locations.count-1{
            for j in 0...locations.count-1{
                if(i > 0 && j > 0){
                var totDist: Double = 0
                locations.swapAt(i, j)
                for x in 1...locations.count-1{
                    totDist += locations[x-1].distance(from: locations[x])
                }
                if totDist < actDist{
                    print(locations.count)
                    actDist = totDist
                    testCoordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
                    testPoly = MKPolyline(coordinates: &testCoordinates, count: locations.count)
                print(totDist)
                    print(actDist)
                    }
                }
            }
        }
        }
        //to this
        
        
        //var coordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
        //var polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        
        //this below finds the region that it should hover
        let polygon = MKPolygon(coordinates: &testCoordinates, count: locations.count)
        
        var lat:Double = 0
        var long:Double = 0
        for i in 0...locations.count-1{
            lat += locations[i].coordinate.latitude
            long += locations[i].coordinate.longitude
        }
        lat = lat/Double(locations.count)
        long = long/Double(locations.count)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let polyRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        //that ends here
        //polyRegion.center.longitude = long
        //polyRegion.center.latitude = lat
        
        ViewController.returnPoly = polygon
        mapView.setRegion(polyRegion, animated:true)
        mapView?.addOverlay(polygon)
        //mapView?.addAnnotations(annotation1)
//         var polylineRenderer = MKPolylineRenderer(overlay: polyline)
//        polylineRenderer.strokeColor = UIColor.blue
//        polylineRenderer.lineWidth = 5
        //mapView?.addOverlay(polyline)
        self.mapView.addOverlay(testPoly)
//        self.mapView.removeOverlay(testPoly)
//        if delete {
//            self.mapView.removeOverlay(testPoly)
//            mapView?.removeOverlay(polygon)
//            delete = false
//        }
        
    }

    func removeMapOverlay() {
        
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    func selectionSort(_ array: [Double]) -> [Double] {
        guard array.count > 1 else { return array }
        
        var arr = array
        
        for x in 0 ..< arr.count - 1 {
            var lowest = x
            for y in x + 1 ..< arr.count {
                if arr[y] < arr[lowest] {
                    lowest = y
                }
            }
            if x != lowest {
                arr.swapAt(x, lowest)
            }
        }
        return arr
    }
    func removeDuplicates(array: [CLLocation]) -> [CLLocation] {
        var encountered = Set<CLLocation>()
        var result: [CLLocation] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    func removeDuplicatesD(array: [Double]) -> [Double] {
        var encountered = Set<Double>()
        var result: [Double] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
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

    
    private func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: [CLAuthorizationStatus]){
        checkLocationAuthorization()
        
    }

}
//
//  ViewController.swift
//  Adopt-A-Plot
//
//  Created by Ari Wasch on 11/2/18.
//  Copyright © 2018 Ari Wasch. All rights reserved.
//



//
//
//
//import UIKit
//import MapKit
//import CoreLocation
//class ViewController: UIViewController, NSURLConnectionDataDelegate, MKMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
//    @IBOutlet weak var pickerView: UIPickerView!
//    @IBOutlet weak var mapView: MKMapView!
//    let locationManager = CLLocationManager()
//    let regionMeters: Double = 1000
//    //    var coord: [Coord] = [Coord]()
//    //    var colors: [String] = [String]()
//    let coord = Coord.getCoords()
//    let colors = ["Red","Yellow","Green","Blue"]
//    let number: [String] = [String]()
//    var n: Int = 0
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.pickerView.delegate = self
//        self.pickerView.dataSource = self
//
//
//        checkLocationServices()
//        addAnnotations()
//
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return coord.count
//        //CHANGE LATER
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return coord[row].getStringName()
//    }
//
//
//
//    func setUpLocationManager(){
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    func centerViewOnUserLocation(){
//        if let location = locationManager.location?.coordinate {
//            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
//            mapView.setRegion(region, animated:true)
//        }
//    }
//    func checkLocationServices(){
//        if(CLLocationManager.locationServicesEnabled()){
//            setUpLocationManager()
//            checkLocationAuthorization()
//        }else{
//
//        }
//    }
//    func checkLocationAuthorization(){
//        switch CLLocationManager.authorizationStatus(){
//        case .authorizedWhenInUse:
//            mapView.showsUserLocation = true
//            centerViewOnUserLocation()
//            locationManager.startUpdatingLocation()
//            break
//        case .denied:
//            break
//        case .restricted:
//            break
//        case .authorizedAlways:
//            break
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//            break
//        }
//    }
//    func createPicker(){
//        let picker = UIPickerView()
//        picker.delegate = self
//    }
//}
//extension ViewController: CLLocationManagerDelegate{
//    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
//        addAnnotations()
//    }
//    func addAnnotations() {
//        //        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.939096,76.469124)
//        //        var coordinate2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(38.938291,76.470182)
//        mapView?.delegate = self
//
//
//        //let coord = Coord.getCoords()
//        //var locations: [CLLocationCoordinate2D] = []
//        //        if let index = coord[2].getInfo().index(of: num) {
//        //            //print("Found peaches at index \(index)")
//        //            .append("This String")
//        //        }
//        let string = "23"
//        for item in coord{
//            if item.getInfo()?.range(of: string) != nil {
//                // locations.append(item.getCoordinates())
//            }
//        }
//        //            if let index = coord[2].getInfo().range(of:"Swift") != nil {
//        //               // locations.add(coord.getCoordinates())
//        //            }
//    }
//    var locations = [CLLocation(latitude: 38.939096, longitude: -76.469124), CLLocation(latitude: 38.938694,longitude: -76.469653), CLLocation(latitude: 38.938282, longitude: -76.469181)]
//    //mapView?.addAnnotations(locations as! [MKAnnotation])
//    var coordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
//    var polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
//    let polygon = MKPolygon(coordinates: &coordinates, count: locations.count)
//    mapView?.addOverlay(polygon)
//    //mapView?.addAnnotations(annotation1)
//    //         var polylineRenderer = MKPolylineRenderer(overlay: polyline)
//    //        polylineRenderer.strokeColor = UIColor.blue
//    //        polylineRenderer.lineWidth = 5
//    //mapView?.addOverlay(polyline)
//    self.mapView.addOverlay(polyline)
//
//
//
//}
//func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//    if overlay is MKCircle {
//        let renderer = MKCircleRenderer(overlay: overlay)
//        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
//        renderer.strokeColor = UIColor.blue
//        renderer.lineWidth = 2
//        return renderer
//
//    } else if overlay is MKPolyline {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = UIColor.orange
//        renderer.lineWidth = 3
//        return renderer
//
//    } else if overlay is MKPolygon {
//        let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
//        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
//        renderer.strokeColor = UIColor.orange
//        renderer.lineWidth = 2
//        return renderer
//    }
//
//    return MKOverlayRenderer()
//}
//
//
//private func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: [CLAuthorizationStatus]){
//    checkLocationAuthorization()
//
//}
//
//
//



