//
//  ConfusionMatrix.swift
//  perceptron_chars
//
//  Created by Ryan Bernstein on 1/11/16.
//  Copyright © 2016 Ryan Bernstein. All rights reserved.
//

import Foundation

class ConfusionMatrix {
    let data: [(input: Letter, guess: Character)]
    
    var accuracy: Double {
        get {
            let correctCount = data.filter({ $0.input.knownValue == $0.guess }).count
            return Double(correctCount) / Double(data.count)
        }
    }
    
    init(withData: [(input: Letter, guess: Character)]) {
        data = withData
    }
}