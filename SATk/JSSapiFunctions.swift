//
//  JSSapiFunctions.swift
//  SATk
//
//  Created by Donovan, Mike on 12/3/17.
//  Copyright © 2017 Donovan, Mike. All rights reserved.
//

import Foundation


class jssCalls {
    
    static func runCommand(args : String...) -> (output: [String], error: [String], exitCode: Int32) {
        
        var output : [String] = []
        var error : [String] = []
        
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe
        
        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output, error, status)
    }
    
    static func getXMLTags(output: [String], tagTitle: String) -> [String] {
        
        let xml = output[0]
        let tT = tagTitle
        let upperTag = "<" + tT + ">"
        let lowerTag = "</" + tT + ""
        let regexVar = "(?s)(?<=" + upperTag + ").*?(?=" + lowerTag + ")"
        let matched = jssCalls.parseXMLwithRegEX(for: regexVar , in: xml)
        
        return matched
    }
    
    
    static func parseXMLwithRegEX(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    

}
