//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by liren on 12/23/15.
//  Copyright © 2015 liren. All rights reserved.
//

import Foundation

class calculatorBrain{
    
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbal, _):
                    return symbal
                case .BinaryOperation(let symbal, _):
                    return symbal
                }
            }
        }
        
        
    }
    
    private var opStack = [Op]()

//    var knowOps = Dictionary<String, Op>()
    private var knowOps = [String: Op]()
    
//    initializer
    init() {
        func learnOp(op: Op) {
            knowOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        knowOps["÷"] = Op.BinaryOperation("÷") { $1 / $0}
        knowOps["+"] = Op.BinaryOperation("+", +)
        knowOps["−"] = Op.BinaryOperation("−") { $1 - $0}
        knowOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case.Operand(let operand):
                return (operand, remainingOps)
            case.UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case.BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbal: String) -> Double? {
        if let operation = knowOps[symbal]{
            opStack.append(operation)
        }
        return evaluate()
    }
}