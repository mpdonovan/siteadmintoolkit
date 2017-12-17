//
//  computersViewController.swift
//  SATk
//
//  Created by Donovan, Mike on 12/16/17.
//  Copyright © 2017 Donovan, Mike. All rights reserved.
//

import Cocoa

class computersViewController: NSViewController {
    
    var apiUser: String = ""
    var apiPass: String = ""
    
    @IBOutlet weak var lblTest1: NSTextField!
    @IBOutlet weak var lblTest2: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lblTest1.stringValue = apiUser
        lblTest2.stringValue = apiPass
        
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if (segue.identifier!.rawValue == "computersReturn") {
            let mainVC = segue.destinationController as! mainInterfaceController;
            mainVC.apiUser = apiUser
            mainVC.apiPass = apiPass
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "computersReturn"), sender: self)
        self.view.window?.close()
    }
}
