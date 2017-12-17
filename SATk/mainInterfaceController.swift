//
//  mainInterfaceController.swift
//  SATk
//
//  Created by Donovan, Mike on 12/16/17.
//  Copyright © 2017 Donovan, Mike. All rights reserved.
//

import Cocoa

class mainInterfaceController: NSViewController {
    
    var apiUser: String = ""
    var apiPass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if (segue.identifier!.rawValue == "computers") {
            let computersVC = segue.destinationController as! computersViewController;
            computersVC.apiUser = apiUser
            computersVC.apiPass = apiPass
        } else if (segue.identifier!.rawValue == "mobiledevices") {
            let mobiledevicesVC = segue.destinationController as! iOSViewController;
            mobiledevicesVC.apiUser = apiUser
            mobiledevicesVC.apiPass = apiPass
        }
    }
    
    
    @IBAction func btnComputers(_ sender: Any) {
        
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "computers"), sender: self)
        self.view.window?.close()
    }
    
    @IBAction func btniOS(_ sender: Any) {
        
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "mobiledevices"), sender: self)
        self.view.window?.close()
    }
}
