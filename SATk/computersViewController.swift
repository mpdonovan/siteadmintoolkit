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
    
    var apiUser: String = ""
    var apiPass: String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func sortByName(_ sender: Any) {
        sortArrayController(by: "name")
    }
    
    @IBAction func sortByAge(_ sender: Any) {
        sortArrayController(by: "age")
    }
    
    func sortArrayController(by key : String) {
        computerRecordArrayController.sortDescriptors = [NSSortDescriptor(key: key, ascending: true)]
        computerRecordArrayController.rearrangeObjects()
    }

}
