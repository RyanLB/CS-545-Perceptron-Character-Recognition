//
//  Perceptron.swift
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
    
    /**
     Tests the accuracy of this Perceptron on the given dataset.
     
     - Parameter data: A series of inputs, along with the desired outputs.
     
     - Returns: The number of examples for which this Perceptron's run() output matches the
       desired output.
     */
    
    func testAccuracy(data: [([Double], Bool)]) -> Int {
        return data.reduce(0, combine: {
            let result = try? run($1.0)
            if result == $1.1 {
                return $0 + 1
            }
            
            return $0
        })
    }
    
    /**
     Trains this Perceptron using stochastic gradient descent.
     
     - Parameter trainingData: The traing dataset, which is an array of inputs and desired outputs.
     
     - Parameter learningRate: The rate by which to modify each weight during the gradient descent.
     */
    
    func train(trainingData: [([Double], Bool)], learningRate: Double) {
        var accuracy = testAccuracy(trainingData)
        var delta: Int
        
        repeat {
            let newPerceptron = epochResult(trainingData, learningRate: learningRate)
            let newAccuracy = newPerceptron.testAccuracy(trainingData)
            delta = newAccuracy - accuracy
        
            if delta >= 0 {
                accuracy = newAccuracy
                bias = newPerceptron.bias
                weights = newPerceptron.weights
            }
        } while delta > 0
    }
    
    /**
     Executes a single training "epoch".
     
     - Returns: A new Perceptron with the resulting bias and weights that the training function
       can use to determine whether or not to continue iterating.
     */
    private func epochResult(trainingData: [([Double], Bool)], learningRate: Double) -> Perceptron {
        let resultPerceptron = Perceptron(withBias: self.bias, andWeights: self.weights)
        
        for instance in trainingData {
            let result = try? resultPerceptron.run(instance.0)
            
            if result != instance.1 {
                resultPerceptron.bias += learningRate * (instance.1 ? 1 : -1)
                resultPerceptron.weights = zip(resultPerceptron.weights, instance.0).map{
                    $0 + (learningRate * $1 * (instance.1 ? 1 : -1))
                }
            }
        }
        
        return resultPerceptron
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