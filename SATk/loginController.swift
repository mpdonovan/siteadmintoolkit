//
//  loginController.swift
//  JSSTool
//
//  Created by Donovan, Mike on 12/16/17.
//  Copyright © 2017 Donovan, Mike. All rights reserved.
//

import Cocoa

class loginController: NSViewController {
    
    @IBOutlet weak var lblLogin: NSTextField!
    @IBOutlet weak var txtApiUser: NSTextField!
    @IBOutlet weak var txtApiPass: NSSecureTextField!
    @IBOutlet weak var txtJSSUrl: NSTextField!
    
    @IBOutlet weak var lblUserLoginStatus: NSTextField!
    
    @IBAction func btnLogin(_ sender: Any) {
        
        let apiUsername = txtApiUser.stringValue
        let apiPassword = txtApiPass.stringValue
        let jssUrl = txtJSSUrl.stringValue
        
        if (apiUsername != "") && (apiPassword != "") && (jssUrl != ""){
            
            let (output, error, status) = jssCalls.runCommand(args: "curl","-H", "Accept: text/xml", "-s","-f","-k","-u", apiUsername + ":" + apiPassword, jssUrl + "/JSSResource/accounts/username/" + apiUsername)
            
            print("program exited with status \(status)")
            
            if status == 0 {
                
                let returnedData = jssCalls.getXMLTags(output: [output[0]],tagTitle: "access_level")
                
                lblUserLoginStatus.stringValue = returnedData[0]
                gotoMain(apiUser: apiUsername)
                
            }else {
                
                lblUserLoginStatus.stringValue = "Access Denied"
                
            }
            
            if error.count > 0 {
                print("error output:")
                print(error)
            }
            
            
        } else {
            
            lblUserLoginStatus.stringValue = "Missing Parameter"
            
        }
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {

        if (segue.identifier!.rawValue == "loginsuccess") {
            let mainVC = segue.destinationController as! mainInterfaceController;
            mainVC.apiUser = txtApiUser.stringValue
            mainVC.apiPass = txtApiPass.stringValue
            mainVC.jssUrl = txtJSSUrl.stringValue
        }
    }
    
    func gotoMain(apiUser: String) {
        
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "loginsuccess"), sender: self)
        self.view.window?.close()
        
    }
    
}
