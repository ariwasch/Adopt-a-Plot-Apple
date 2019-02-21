//
//  SecondViewController.swift
//  Adopt-A-Plot
//
//  Created by Ari Wasch on 11/29/18.
//  Copyright © 2018 Ari Wasch. All rights reserved.
//

import Foundation
import UIKit

class SecondController: UIViewController{
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    var truth = createView()
    var stupid = MorePlots()
    var plots = ViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = stupid.updateOrg()
        label2.text = "Plot Num: " + plots.updatePlotNum()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if(truth.updateTruth()){
            createView.isCostum = true
        }else{
            createView.isCostum = false
        }
        if(plots.updatePlotNum() == ""){
            createView.noPlot = true
        }else{
            createView.noPlot = false
        }
        if (createView.isCostum){
            
            label2.text = "Plot Num: Custom Plot"
        }else if(createView.noPlot && truth.updateCustom().count <= 0){
             label2.text = "NO PLOT SELECTED"
        }else{
        label.text = stupid.updateOrg()
        label2.text = "Plot Num: " + plots.updatePlotNum()
        }
    }
    func which() -> String{
        var thing = ""
        if(truth.updateTruth()){
            createView.isCostum = true
        }else{
            createView.isCostum = false
        }
        if(plots.updatePlotNum() == ""){
            createView.noPlot = true
        }else{
            createView.noPlot = false
        }
        if (createView.isCostum){
            
            thing = "Plot: Custom Plot"
        }else if(createView.noPlot && truth.updateCustom().count <= 0){
            thing = "NO PLOT SELECTED"
        }else{
            thing = "Plot: " + plots.updatePlotNum() + " " + stupid.updateOrg()
        }
        return thing
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func changeText(sender: AnyObject){
        
    }
    
}
