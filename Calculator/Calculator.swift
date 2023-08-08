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
    case sqrt
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
        case .sqrt:
            self.result = sqrt(mathOperation.operand1)
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
    
    
    func calculateAverage(values: [Double]){
        for i in 0...values.count-2{
            performOperation(MathOperation(operand1: values[i], operand2: values[i+1], operationType: .addition))
        }
        
        performOperation(MathOperation(operand1: result!, operand2: Double(values.count), operationType: .division))
        
    }
    

    func calculateFactorial(value: Int){
        result = Double(value)
        for i in stride(from: value-1, to: 1, by: -1){
            performOperation(MathOperation(operand1: Double(result!), operand2: Double(i), operationType: .multiplication))
        }
    }
    

    func calculatePower(base: Double, exponent: Double){
        result = base
        for _ in 0...Int(exponent)-2 {
            performOperation(MathOperation(operand1: result!, operand2: base, operationType: .multiplication))
        }
    }
    

    func calculateSquareRoot(value: Double){
        let mathOperation = MathOperation(operand1: 9, operand2: 0.0, operationType: .sqrt)
        performOperation(mathOperation)
    }

    func calculatePercentage(value: Double, percentage: Double){
        performOperation(MathOperation(operand1: value, operand2: 100, operationType: .division))
        performOperation(MathOperation(operand1: result!, operand2: percentage, operationType: .multiplication))
    }
}
