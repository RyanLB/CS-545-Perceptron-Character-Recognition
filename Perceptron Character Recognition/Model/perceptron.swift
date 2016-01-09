//
//  perceptron.swift
//  Perceptron Character Recognition
//
//  Created by Ryan Bernstein on 1/7/16.
//  Copyright © 2016 Ryan Bernstein. All rights reserved.
//

import Foundation

class Perceptron {
    let bias: Double
    let weights: Array<Double>
    
    // Initialize with random weights
    init() {
        bias = Perceptron.smallRandom()
        
        var weightArray:[Double] = []
        for _ in [0..<16] {
            weightArray.append(Perceptron.smallRandom())
        }
        
        weights = weightArray
    }
    
    init(withBias: Double, andWeights: Array<Double>) {
        bias = withBias
        weights = andWeights
    }
    
    private class func smallRandom() -> Double {
        let randVal = drand48()
        if arc4random_uniform(2) == 0 {
            return -randVal
        }
        
        return randVal
    }
}