//
//  computersViewController.swift
//  SATk
//
//  Created by Donovan, Mike on 12/16/17.
//  Copyright © 2017 Donovan, Mike. All rights reserved.
//

import Cocoa

class computersViewController: NSViewController {
    @IBOutlet var computerRecordArrayController: NSArrayController!
    @IBOutlet weak var tblComputers: NSTableView!
    
    var sortDirection = "ascending"
    
    var apiUser: String = ""
    var apiPass: String = ""
    var jssUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let apiUser = self.apiUser
        let apiPass = self.apiPass
        let jssUrl = self.jssUrl
        
        let computers = [("m111-128005", "111456789012", "111456"),("m222-128005", "222456789012", "222456"),("m333-128005", "333456789012", "333456")]
        for (name, serialNum, jssID) in computers {
            let computerRecord = Computer(name: name, serialNum: serialNum, jssID: jssID)
            computerRecordArrayController.addObject(computerRecord)
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if (segue.identifier!.rawValue == "computersReturn") {
            let mainVC = segue.destinationController as! mainInterfaceController;
            mainVC.apiUser = apiUser
            mainVC.apiPass = apiPass
        }
    }
    
    @IBAction func btnRemoveRow(_ sender: NSButton) {
        
        let row = self.tblComputers.row(for: sender)
        
        self.computerRecordArrayController.remove(atArrangedObjectIndex: row)
        tblComputers.reloadData()
    }
    @IBAction func btnRemoveSelectedRow(_ sender: NSButton) {
        
        if(tblComputers.selectedRow > -1){
            self.computerRecordArrayController.remove(atArrangedObjectIndex: tblComputers.selectedRow)
        }
        tblComputers.reloadData()
        
    }
    @IBAction func btnBack(_ sender: Any) {
        
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "computersReturn"), sender: self)
        self.view.window?.close()
    }
    
    func getDataFromRow () {
        //needs to be used in a button action
        //        let row = self.tblComputers.row(for: sender)
        //
        //        let myvar = ((self.computerRecordArrayController.arrangedObjects as AnyObject).object(at: row) as AnyObject).value(forKey: "name")!
        //
        //        print(myvar)
    }
    
    @IBAction func chkSelectRow(_ sender: NSButton) {
        
        let row = self.tblComputers.row(for: sender)
        
        let myvar = ((self.computerRecordArrayController.arrangedObjects as AnyObject).object(at: row) as AnyObject).value(forKey: "name")!
        
        print(myvar)
        
    }
    
    @IBAction func btnSortByName(_ sender: Any) {
        if sortDirection == "ascending" {
            sortArrayController(by: "name", ascendVal: true)
            sortDirection = "descending"
        }else {
            sortArrayController(by: "name", ascendVal: false)
            sortDirection = "ascending"
        }
    }
    
    @IBAction func btnSortBySerial(_ sender: Any) {
        if sortDirection == "ascending" {
            sortArrayController(by: "serialNum", ascendVal: true)
            sortDirection = "descending"
        }else {
            sortArrayController(by: "serialNum", ascendVal: false)
            sortDirection = "ascending"
        }
    }
    
    @IBAction func btnSortByJssID(_ sender: Any) {
        if sortDirection == "ascending" {
            sortArrayController(by: "jssID", ascendVal: true)
            sortDirection = "descending"
        }else {
            sortArrayController(by: "jssID", ascendVal: false)
            sortDirection = "ascending"
        }
    }
    
    func sortArrayController(by key : String, ascendVal: Bool) {
        computerRecordArrayController.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascendVal)]
        computerRecordArrayController.rearrangeObjects()
    }
    
    func getComputerStaticGroupList() {
        
        if (apiUser != "") && (apiPass != "") && (jssUrl != ""){
            
            let (output, error, status) = jssCalls.runCommand(args: "curl","-H", "Accept: text/xml", "-s","-f","-k","-u", apiUser + ":" + apiPass, jssUrl + "/JSSResource/computergroups" + " -X GET 2>/dev/null | xmllint --format - | grep -B1 '<is_smart>false</is_smart>' | awk -F'>|<' '/<name>/{print $3}'")
            
//            set SerialGroupList to do shell script "curl -u " & apiuser & ":'" & apipass & "' " & jssurl & "/JSSResource/" & gT & " -X GET 2>/dev/null | xmllint --format - | grep -B1 '<is_smart>" & gS & "</is_smart>' | awk -F'>|<' '/<name>/{print $3}'" as string
            
            print("program exited with status \(status)")
            
            if status == 0 {
                
                let returnedData = jssCalls.getXMLTags(output: [output[0]],tagTitle: "access_level")
                
//                lblUserLoginStatus.stringValue = returnedData[0]
//                gotoMain(apiUser: apiUsername)
                
            }else {
                
//                lblUserLoginStatus.stringValue = "Access Denied"
                
            }
            
            if error.count > 0 {
                print("error output:")
                print(error)
            }
            
            
        } else {
            
//            lblUserLoginStatus.stringValue = "Missing Parameter"
            
        }
    }

}
