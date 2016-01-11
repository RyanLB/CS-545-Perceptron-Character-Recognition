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
    
    func loadTrainingData(fromPath: String) throws {
        let trainingArray = try! loadLetters(fromPath)
        for l in trainingArray {
            trainingData[l.knownValue]!.append(l)
        }
    }
    
    func loadTestData(fromPath: String) throws {
        testData = try loadLetters(fromPath)
    }
    
    func getTestResults() -> [(input: Letter, guess: Character)] {
        return testData.map{ ($0, recognitionNetwork.identify($0)) }
    }
    
    func trainNetwork() {
        recognitionNetwork.trainPerceptrons(trainingData, learningRate: 0.2)
    }
    
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
    
    private class func emptyLetterCollection() -> [Character: [Letter]] {
        var collection = [Character: [Letter]]()
        for i in 65...90 {
            collection[Character(UnicodeScalar(i))] = []
        }
        
        return collection
    }
}