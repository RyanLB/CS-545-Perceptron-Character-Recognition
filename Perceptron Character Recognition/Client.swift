//
//  Client.swift
//  perceptron_chars
//
//  Created by Ryan Bernstein on 1/9/16.
//  Copyright © 2016 Ryan Bernstein. All rights reserved.
//

import Foundation

enum LRClientError : ErrorType {
    case InvalidFilepath(path: String)
}

class LetterRecognitionClient {
    var trainingData: [Character: [Letter]]
    var testData: [Letter]
    var recognitionNetwork = LetterRecognitionNetwork(withAttributeCount: 16)
    
    init() {
        trainingData = LetterRecognitionClient.emptyLetterCollection()
        testData = [Letter]()
    }
    
    /// Wrapper function to load training data from a  file.
    func loadTrainingData(fromPath: String) throws {
        let trainingArray = try! loadLetters(fromPath)
        for l in trainingArray {
            trainingData[l.knownValue]!.append(l)
        }
    }
    
    /// Wrapper function to load test data from a file.
    func loadTestData(fromPath: String) throws {
        testData = try loadLetters(fromPath)
    }
    
    
    func getTestResults() -> [(input: Letter, guess: Character)] {
        return testData.map{ ($0, recognitionNetwork.identify($0)) }
    }
    
    /// Wrapper function that trains the LetterRecognitionNetwork's Perceptrons.
    func trainNetwork() {
        recognitionNetwork.trainPerceptrons(trainingData, learningRate: 0.2)
    }
    
    /**
     Loads an array of Letter objects from a file at the given path.
     
     - Parameter fromPath: The relative path of the file from which to load Letters.
     
     - Returns: A list of Letter objects.
     */
    private func loadLetters(fromPath: String) throws -> [Letter] {
        let inputHandle = NSFileHandle(forReadingAtPath: fromPath)
        
        if inputHandle == nil {
            throw LRClientError.InvalidFilepath(path: fromPath)
        }
        
        var results = [Letter]()
        
        repeat {
            if let line = inputHandle?.getASCIILine() {
                let letter = Letter.init(withCommaSeparatedAttributeList: line)
                results.append(letter)
            }
            else {
                break
            }
            
        } while true
        
        inputHandle!.closeFile()
        
        return results
    }
    
    /// Returns a new, empty dictionary mapping Characters to lists of Letters.
    private class func emptyLetterCollection() -> [Character: [Letter]] {
        var collection = [Character: [Letter]]()
        for i in 65...90 {
            collection[Character(UnicodeScalar(i))] = []
        }
        
        return collection
    }
}