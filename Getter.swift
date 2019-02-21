//
//  Getter.swift
//  Adopt-A-Plot
//
//  Created by Ari Wasch on 11/3/18.
//  Copyright © 2018 Ari Wasch. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import Foundation
    @objc class Coord: NSObject {
        static var stupid = MorePlots()
        var coordinate: CLLocationCoordinate2D
        var pole: String?
        var point: Int
        static var text: String?
        static public var data = ""
        init(coordinate: CLLocationCoordinate2D, pole: String?, point: Int) {
            self.coordinate = coordinate
            self.point = point
            self.pole = pole
            

        }
        func getLatitude() -> Double{
            return coordinate.latitude
        }
        func getLongitude() -> Double{
            return coordinate.longitude
        }
        func getStringName() -> String?{
            var result: String
            result = String(point)
            return result
        }
        func getInfo() -> String?{
            return pole
        }
        func getCoordinates() -> CLLocationCoordinate2D{
            return coordinate
        }
        private static func whichPlot() -> String{
            text = stupid.updateOrg()
            if (text?.contains("no"))!{
                data = "data"
                print("true")
            }else if (text?.contains("Bay Ridge"))!{
                data = "data"
                print("true2")
            }
           print("finder ", data)
            return data
        }
    public static func getCoords() -> [Coord] {
//        data = whichPlot()
        //above returned a blank data set
        //something is definetely wrong with having multiple organizations
        data = "data"
        guard let path = Bundle.main.path(forResource: data, ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }
        
        var coords = [Coord]()
        
        for item in array {
            let dictionary = item as? [String : Any]
            let point = dictionary?["Point Number"] as? Int
            let pole = dictionary?["Description"] as? String
            let latitude = dictionary?["Latitude (DD)"] as? Double ?? 0, longitude = dictionary?["Longitude (DD)"] as? Double ?? 0
            
            let theCoordinate = Coord(coordinate: CLLocationCoordinate2DMake(latitude, -longitude), pole: pole, point: point as! Int)
            coords.append(theCoordinate)
        }
        
        return coords as [Coord]
    }
}

