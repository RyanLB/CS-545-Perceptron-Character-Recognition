//
//  main.swift
//  Perceptron Character Recognition
//
//  Created by Ryan Bernstein on 1/7/16.
//  Copyright © 2016 Ryan Bernstein. All rights reserved.
//

import Foundation

print(Process.arguments[0])

if Process.arguments.count < 2 {
    print("usage: perceptron_chars [training data path] [test data path]")
    exit(EXIT_FAILURE)
}

let path = Process.arguments[1]
let trainingHandle = NSFileHandle(forReadingAtPath: Process.arguments[1])

if trainingHandle == nil {
    print("Invalid filepath for training data.")
    exit(EXIT_FAILURE)
}

let firstLine = trainingHandle!.getASCIILine()!
let firstLetter = Letter(withCommaSeparatedAttributeList: firstLine)
print(firstLine)

/*while let line = handle?.getLine() {
    NSLog("LINE: %s\n", line)
}
*/

