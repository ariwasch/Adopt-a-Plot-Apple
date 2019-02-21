//
//  starterView.swift
//  Adopt-A-Plot
//
//  Created by Ari Wasch on 11/30/18.
//  Copyright © 2018 Ari Wasch. All rights reserved.
//

import Foundation
import UIKit
class StarterView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var pickerView: UIPickerView!
    
    let coord = Coord.getCoords()
    let number: [String] = [String]()
    var plotNum = [Int]()
    var selected = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        //plots for each placew
        if(MorePlots.ind == 0){
        for i in 0...120{
            plotNum.append(i)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
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
        selected = String(row)
        //removeMapOverlay()
        //addAnnotations()


        //remove annotation before changing it.

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(plotNum[row])
    }
    func createPicker(){
        let picker = UIPickerView()
        picker.delegate = self
    }
}
