//
//  NSFileHandleExtension.swift
//  perceptron_chars
//
//  Created by Ryan Bernstein on 1/8/16.
//  Copyright © 2016 Ryan Bernstein. All rights reserved.
//

import Foundation

extension NSFileHandle {
    func getASCIIChar() -> Character? {
        let byteData = readDataOfLength(1)
        
        guard byteData.length > 0 else {
            return nil
        }
        
        let dataString = String(data: byteData, encoding: NSASCIIStringEncoding)
        
        return dataString?[(dataString?.startIndex)!]
    }
    
    func getASCIILine() -> String? {
        var chars = ""
        
        while let c = getASCIIChar() {
            if c == "\n" {
                return chars
            }
            
            chars.append(c)
        }
        
        return chars == "" ? nil : chars
    }
}