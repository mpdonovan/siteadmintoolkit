//
//  ComputerRecord.swift
//  tableViewTest
//
//  Created by Donovan, Mike on 12/17/17.
//  Copyright © 2017 Donovan, Mike. All rights reserved.
//

import Foundation

class Computer: NSObject {
    
    @objc var name: String
    @objc var serialNum: String
    @objc var jssID: String
    
    init(name: String, serialNum: String, jssID: String) {
        self.name = name
        self.serialNum = serialNum
        self.jssID = jssID
    }
}
