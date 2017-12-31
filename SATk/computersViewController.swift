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
    @IBOutlet weak var cmbComputerGroupList: NSComboBox!
    
    @IBOutlet weak var lblGrpName: NSTextField!
    @IBOutlet weak var lblGrpType: NSTextField!
    @IBOutlet weak var lblGrpCount: NSTextField!

    
    var sortDirection = "ascending"
    
    var apiUser: String = ""
    var apiPass: String = ""
    var jssUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        let apiUser = self.apiUser
//        let apiPass = self.apiPass
//        let jssUrl = self.jssUrl
        
        getComputerGroupList()
        
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if (segue.identifier!.rawValue == "computersReturn") {
            let mainVC = segue.destinationController as! mainInterfaceController;
            mainVC.apiUser = apiUser
            mainVC.apiPass = apiPass
            mainVC.jssUrl = jssUrl
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
    
    func getComputerGroupList() {
        
        if (apiUser != "") && (apiPass != "") && (jssUrl != ""){
              
            let (output, error, status) = jssCalls.runCommand(args: "curl","-H", "Accept: text/xml", "-s","-f","-k","-u", apiUser + ":" + apiPass, jssUrl + "/JSSResource/computergroups")
            
            print("program exited with status \(status)")
            
            if status == 0 {
                
                let returnedDataGroupNames = jssCalls.getXMLTags(output: [output[0]],tagTitle: "name")
                
                cmbComputerGroupList.addItems(withObjectValues: returnedDataGroupNames)
                
            }else {
                print("Error in Curl statement")
                
            }
            
            if error.count > 0 {
                print("error output:")
                print(error)
            }
            
            
        } else {
            print("Missing parameter: U:\(apiUser) P:\(apiPass) J:\(jssUrl)")
            
        }
    }
    
    @IBAction func cmbCompGrpList(_ sender: NSComboBox) {
        
        let range = NSMakeRange(0, (computerRecordArrayController.arrangedObjects as AnyObject).count)
        computerRecordArrayController.remove(atArrangedObjectIndexes: NSIndexSet(indexesIn: range) as IndexSet)
        
        let characterSet: CharacterSet = CharacterSet(charactersIn: " /#").inverted
        
        let selectedGroup = cmbComputerGroupList.objectValueOfSelectedItem as! String
        
        lblGrpName.stringValue = selectedGroup
        
        let selGrp = selectedGroup.addingPercentEncoding(withAllowedCharacters: characterSet) as AnyObject
        
        
        let (output, error, status) = jssCalls.runCommand(args: "curl","-H", "Accept: text/xml", "-s","-k","-u", apiUser + ":" + apiPass, jssUrl + "/JSSResource/computergroups/name/\(selGrp)")
        
//        if output.count > 0 {
//            print("program output:")
//            print(output)
//        }
        
        print("program exited with status \(status)")
        
        if status == 0 {
            
            let grpType = jssCalls.getXMLTags(output: [output[0]],tagTitle: "is_smart")
            
            if grpType[0] == "true" {
                
                lblGrpType.stringValue = "Smart"
            } else {
                lblGrpType.stringValue = "Static"
            }
            
            let returnedData = jssCalls.getXMLTags(output: [output[0]],tagTitle: "computers")
            //print(returnedData)
            
            let grpCount = jssCalls.getXMLTags(output: [returnedData[0]],tagTitle: "size")
            lblGrpCount.stringValue = grpCount[0]
            
            let returnedDataID = jssCalls.getXMLTags(output: [returnedData[0]],tagTitle: "id")
            //print(returnedDataID)
            
            let returnedDataName = jssCalls.getXMLTags(output: [returnedData[0]],tagTitle: "name")
            //print(returnedDataName)
            
            let returnedDataSerial = jssCalls.getXMLTags(output: [returnedData[0]],tagTitle: "serial_number")
            //print(returnedDataSerial)
            
            for (index, _) in returnedDataName.enumerated() {
                let computerRecord = Computer(name: returnedDataName[index], serialNum: returnedDataSerial[index], jssID: returnedDataID[index])
                computerRecordArrayController.addObject(computerRecord)
            }
            
            
        }else {
            print("Error in Curl statement")
            
        }
        
        
        if error.count > 0 {
            print("error output:")
            print(error)
        }
        
        
        
    }
    
    

}
