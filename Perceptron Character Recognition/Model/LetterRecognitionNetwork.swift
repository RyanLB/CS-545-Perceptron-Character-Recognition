//
//  LetterRecognitionNetwork.swift
//  perceptron_chars
//
//  Created by Ryan Bernstein on 1/9/16.
//  Copyright © 2016 Ryan Bernstein. All rights reserved.
//

import Foundation

enum NeuralNetworkError : ErrorType {
    case CharacterOutOfRange(c: Character)
    case SelfComparison(c: Character)
    case NotFoundError(c1: Character, c2: Character)
}

class LetterRecognitionNetwork {
    let attributeCount: Int
    private var perceptronNetwork = [Character: [Character: Perceptron]]()
    
    init(withAttributeCount: Int) {
        attributeCount = withAttributeCount
        for ordinal in 65..<90  {
            let c1 = Character(UnicodeScalar(ordinal))
            var subNetwork = [Character: Perceptron]()
            for ordinal2 in (ordinal + 1)...90 {
                let c2 = Character(UnicodeScalar(ordinal2))
                subNetwork[c2] = Perceptron(withWeightCount: attributeCount)
            }
            perceptronNetwork[c1] = subNetwork
        }
    }
    
    func trainPerceptrons(trainingData: [Character: [Letter]], learningRate: Double) {
        for (c1, subNetwork) in perceptronNetwork {
            for (c2, p) in subNetwork {
                
                var relevantExamples = [([Double], Bool)]()
                if let c1Examples = trainingData[c1] {
                    relevantExamples += c1Examples.map({ (l: Letter) -> ([Double], Bool) in (l.attributeVector, false) } )
                }
                if let c2Examples = trainingData[c2] {
                    relevantExamples += c2Examples.map({ (l: Letter) -> ([Double], Bool) in (l.attributeVector, true) } )
                }
                
                p.train(relevantExamples, learningRate: learningRate)
            }
        }
    }
    
    /**
     Uses all-pairs classification to attempt to determine which letter this example represents.
     
     - Returns: The letter with the highest number of "votes". Ties are broken via random number generation.
     */
    func identify(letter: Letter) -> Character {
        var results = [Int](count: 26, repeatedValue: 0)
        
        for (c1, subnetwork) in perceptronNetwork {
            for (c2, p) in subnetwork {
                if let result = try? p.run(letter.attributeVector) ? c2 : c1 {
                    ++results[charToAZIndex(result)]
                }
            }
        }

        let winners = results.indicesOf{ $0 == results.maxElement() }
        
        // Break ties by picking a random number between 0 and winners.count
        let winIndex = Int(arc4random_uniform(UInt32(winners.count)))
        return Character(UnicodeScalar(winners[winIndex] + 65))
    }
    
    /**
     Helper function that converts a character to an array index between 0 and 25.
     
     Assumes that this is a capital letter between "A" and "Z", ASCII encoded.
     */
    private func charToAZIndex(c: Character) -> Int {
        let s = String(c).unicodeScalars
        return Int(s[s.startIndex].value) - 65
    }
    
}