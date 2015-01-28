//
//  ViewController.swift
//  Calculator
//
//  Created by Aykut Aras on 27/01/15.
//  Copyright (c) 2015 Aykut Aras. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingANumber: Bool = false;
    var userAlreadyUsedFloatinPoint = false
    
    var operandStack: Array<Double> = Array<Double>()
    
    @IBAction func operation(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." {
            if userAlreadyUsedFloatinPoint {
                return
            }
            
            userAlreadyUsedFloatinPoint = true
        }
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit == "." ? "0." : digit
            userIsInTheMiddleOfTypingANumber = true;
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        userAlreadyUsedFloatinPoint = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    var displayValue: Double {
        get {
            let displayText = display.text!
            
            if displayText == "π" {
                return M_PI
            }
            
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

