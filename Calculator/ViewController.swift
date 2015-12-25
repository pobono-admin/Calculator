//
//  ViewController.swift
//  Calculator
//
//  Created by liren on 12/15/15.
//  Copyright © 2015 liren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = calculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
//      print("digit = \(digit)")
//      let = constnat, little different with var
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
//    
//    func performOperation(operation: (Double, Double) -> Double) {
//        if operandStack.count >= 2 {
//            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
//            enter()
//            //Thread 1: breakpoint 1.1    CMD + 7
//        }
//    }
//    
//    func performOperation2(operation: Double -> Double) {
//        if operandStack.count >= 1 {
//            displayValue = operation(operandStack.removeLast())
//            enter()
//        }
//    }
    
//    var operandStack = Array<Double>()
//    enpty array
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else {
            displayValue = 0
        }
    }

    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
         set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

