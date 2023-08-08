//  Calculator.swift
//  Calculator
//
//  Created by Suren Poghosyan on 07.08.23.


import Foundation


enum OperationType {
    case addition
    case subtraction
    case multiplication
    case division
}

struct MathOperation {
    var operand1: Double
    var operand2: Double
    var operationType: OperationType
}

final public class Calculator {
    var result: Double?

    func performOperation(_ mathOperation: MathOperation) {
        switch mathOperation.operationType {
        case .addition:
            self.result = mathOperation.operand1 + mathOperation.operand2
        case .division:
            self.result = mathOperation.operand1 / mathOperation.operand2
        case .multiplication:
            self.result = mathOperation.operand1 * mathOperation.operand2
        case .subtraction:
            self.result = mathOperation.operand1 - mathOperation.operand2
        }
    }    
    
    init(result: Double? = nil) {
        self.result = result
    }
    
    func add(value1: Double, value2: Double){
        let mathOperation = MathOperation(operand1: value1, operand2: value2, operationType: .addition)
        performOperation(mathOperation)
        
        
    }
    
    func subtraction(value1: Double, value2: Double){
        let mathOperation = MathOperation(operand1: value1, operand2: value2, operationType: .subtraction)
        performOperation(mathOperation)
        
    }

    func multiplication(value1: Double, value2: Double){
        let mathOperation = MathOperation(operand1: value1, operand2: value2, operationType: .multiplication)
        performOperation(mathOperation)
    }

    func division(value1: Double, value2: Double){
        let mathOperation = MathOperation(operand1: value1, operand2: value2, operationType: .division)
        performOperation(mathOperation)
    }
    
    
    func clearResult(){
        self.result = 0;
    }

    func calculatePercentage(value: Double, percentage: Double){
        performOperation(MathOperation(operand1: value, operand2: 100, operationType: .division))
        performOperation(MathOperation(operand1: result!, operand2: percentage, operationType: .multiplication))
    }
}
