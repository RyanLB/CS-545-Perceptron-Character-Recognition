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
    
    func perceptronFor(c1: Character, c2: Character) throws -> Perceptron {
        guard c1 != c2 else {
            throw NeuralNetworkError.SelfComparison(c: c1)
        }
        
        let s1 = String(c1).unicodeScalars
        let ord1 = s1[s1.startIndex].value
        
        let s2 = String(c2).unicodeScalars
        let ord2 = s2[s2.startIndex].value
        
        guard (65...90).contains(ord1) else {
            throw NeuralNetworkError.CharacterOutOfRange(c: c1)
        }
        
        guard (65...90).contains(ord2) else {
            throw NeuralNetworkError.CharacterOutOfRange(c: c2)
        }
        
        if ord2 < ord1 {
            return try perceptronFor(c2, c2: c1)
        }
        
        if let p = perceptronNetwork[c1]?[c2] {
            return p
        }
        
        throw NeuralNetworkError.NotFoundError(c1: c1, c2: c2)
    }
    
    func perceptronsContaining(c: Character) throws -> [Perceptron] {
        let s = String(c).unicodeScalars
        let ord = s[s.startIndex].value
        
        guard (65...90).contains(ord) else {
            throw NeuralNetworkError.CharacterOutOfRange(c: c)
        }
        
        let precedents = try (65..<ord).map{ try perceptronFor(Character(UnicodeScalar($0)), c2: c) }
        let antecedents = try ((ord + 1)...90).map{ try perceptronFor(c, c2: Character(UnicodeScalar($0))) }
        
        return precedents + antecedents
    }
}