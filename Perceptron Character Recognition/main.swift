//
//  main.swift
//  Perceptron Character Recognition
//
//  Created by Ryan Bernstein on 1/7/16.
//  Copyright © 2016 Ryan Bernstein. All rights reserved.
//

import Foundation

print(Process.arguments[0])

if Process.arguments.count < 3 {
    print("usage: perceptron_chars [training data path] [test data path]")
    exit(EXIT_FAILURE)
}