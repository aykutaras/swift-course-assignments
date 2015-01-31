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
    @IBOutlet weak var history: UITextView!
    
    
    var userIsInTheMiddleOfTypingANumber: Bool = false;
    var operationPerformed: Bool = false
    var operandStack: Array<Double> = Array<Double>()
    
    @IBAction func operation(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." && display.text!.rangeOfString(digit) != nil { return }
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true;
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        addHistory(operation)
        
        operationPerformed = true;
        switch operation {
            case "×": performOperation { $0 * $1 }
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $1 - $0 }
            case "sin": performOperation { sin($0) }
            case "cos": performOperation { cos($0) }
            case "√": performOperation { sqrt($0) }
            case "π": performOperation(M_PI)
            default: break
        }
    }
    
    @IBAction func clear() {
        enter()
        displayValue = 0;
        operandStack = Array<Double>()
        history.text = ""
    }
    
    @IBAction func backspace() {
        display.text = dropLast(display.text!)
        
        if countElements(display.text!) == 0 {
            displayValue = 0
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if (displayValue != nil) {
            operandStack.append(displayValue!)
            println("operandStack = \(operandStack)")
            addHistory((operationPerformed ? "= " : "") + "\(displayValue!)")
            operationPerformed = false
        }
    }
    
    func performOperation(operation: (Double)) {
        displayValue = operation
        enter()
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
    
    func addHistory(item: String) {
        history.text = item + "\n" + history.text!
    }
    
    var displayValue: Double? {
        get {
            let value = NSNumberFormatter().numberFromString(display.text!)
            return value == nil ? nil : value!.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

