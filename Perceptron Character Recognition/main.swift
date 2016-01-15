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
    print("usage: perceptron_chars training_path test_path [output_path]")
    exit(EXIT_FAILURE)
}

let client = LetterRecognitionClient()
try client.loadTrainingData(Process.arguments[1])
try client.loadTestData(Process.arguments[2])

/*
print("Calculating initial accuracy...", separator: "")
let initialMat = ConfusionMatrix(withData: client.getTestResults())
print("Done.")
print("Initial accuracy: ", initialMat.accuracy)
*/
print("Training perceptrons...", separator: "")
client.trainNetwork()
print("Done.")
print("Calculating final accuracy...", separator: "")

let finalMat = ConfusionMatrix(withData: client.getTestResults())
print("Done.")
print("Final accuracy: ", finalMat.accuracy)
print(finalMat.toCSVString())