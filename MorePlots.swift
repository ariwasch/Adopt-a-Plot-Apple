//
//  starterView.swift
//  Adopt-A-Plot
//
//  Created by Ari Wasch on 11/30/18.
//  Copyright © 2018 Ari Wasch. All rights reserved.
//

import Foundation
import UIKit
class MorePlots: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    

    @IBOutlet weak var pickerView: UIPickerView!
    var names = [String]()
    public static var ind = 0
    public static var org = ""
    var test = "hi"
    var name = ""
    var temp = "0"
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        //addAnnotations()
        
        names.append("Adopt-A-Plot, Bay Ridge")
        // Do any additional setup after loading the view, typically from a nib.
        if let orges = defaults.string(forKey: "num"){
            temp = orges
        }
        MorePlots.ind = Int(temp)!
        if let orge = defaults.string(forKey: "org"){
            MorePlots.org = orge
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBAction func onPress(sender: UIButton){
        //did not work, with below, so I took it out. not neccessary
        //unless I add more adopt-a-plot organizations
//        UserDefaults.standard.set(MorePlots.ind, forKey: "num")
//        UserDefaults.standard.set(MorePlots.org, forKey: "org")
        
        
    }
    func updateOrg() -> String{
        var temp = ""
        if let orge = defaults.string(forKey: "org"){
            temp = orge
        }
        return temp
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return coord.count
        return names.count
        //CHANGE LATER
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        //delete = true
        name = names[row]
        MorePlots.org = name
        //removeMapOverlay()
        //addAnnotations()
        
        
        //remove annotation before changing it.
        
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = names[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return myTitle
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        MorePlots.ind = row
        name = names[row]
        MorePlots.org = name
        return names[row]
    }
    func createPicker(){
        let picker = UIPickerView()
        picker.delegate = self
    }
}
