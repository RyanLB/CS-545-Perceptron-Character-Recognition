//
//  perceptron.swift
//  Perceptron Character Recognition
//
//  Created by Ryan Bernstein on 1/7/16.
//  Copyright © 2016 Ryan Bernstein. All rights reserved.
//

import Foundation

enum PerceptronError : ErrorType {
    case InvalidLength(length: Int)
    case NonMatchingLengths(l1: Int, l2: Int)
}

class Perceptron {
    let weightCount: Int
    
    var bias: Double
    private var _weights: [Double]
    
    var weights: [Double] {
        get {
            return _weights
        }
        set {
            if newValue.count == weightCount {
                _weights = newValue
            }
        }
    }
    
    // Initialize with random weights
    init(withWeightCount: Int) {
        weightCount = withWeightCount
        bias = Perceptron.smallRandom()
        
        var weightArray:[Double] = []
        for _ in [0..<weightCount] {
            weightArray.append(Perceptron.smallRandom())
        }
        
        _weights = weightArray
    }
    
    convenience init() {
        self.init(withWeightCount: 16)
    }
    
    init(withBias: Double, andWeights: [Double]) {
        bias = withBias
        weightCount = andWeights.count
        _weights = andWeights
    }
    
    /**
     Runs this Perceptron on the given array of inputs.
     
     - Parameter inputArray: The input vector on which to test this Perceptron.
     
     - Throws: `NonMatchingLengths` if `inputArray.count != weightCount`.
     
     - Returns: `true` if the Perceptron "fires" and false otherwise.

     */
    
    func run(inputArray: [Double]) throws -> Bool {
        guard inputArray.count == weightCount else {
            throw PerceptronError.NonMatchingLengths(l1: weightCount, l2: inputArray.count)
        }
        
        return try (bias + dotProduct(inputArray, secondArr: weights)) >= 0
    }
    
    func testAccuracy(trainingData: [([Double], Bool)]) -> Int {
        return trainingData.reduce(0, combine: {
            let result = try? run($1.0)
            if result == $1.1 {
                return $0 + 1
            }
            
            return $0
        })
    }
    

    ///Generates a small random number between -1 and 1.
    
    private class func smallRandom() -> Double {
        let randVal = drand48()
        if arc4random_uniform(2) == 0 {
            return -randVal
        }
        
        return randVal
    }
    
    /**
     Calculates the dot product of two Double arrays.
     
     - Throws: `NonMatchingLengths` if the two input arrays have differeing lenghts.
     */
    
    private func dotProduct(firstArr: [Double], secondArr: [Double]) throws -> Double {
        guard firstArr.count == secondArr.count else {
            throw PerceptronError.NonMatchingLengths(l1: firstArr.count, l2: secondArr.count)
        }
        
        return zip(firstArr, secondArr).reduce(0.0, combine: { $0 + ($1.0 * $1.1) })
    }
}