//  Calculator.swift
//  Calculator
//
//  Created by Suren Poghosyan on 07.08.23.


import Foundation



final public class Calculator {
    private(set) var result: Double?
    
    private(set) var operand1: Double? {
        didSet {
            if let operand1 {
                if oldValue != nil {
                    self.operand1 = Double(String(Int(result!)) + String(Int(operand1)))
                    result = self.operand1
                } else {
                    result = operand1
                }
            }
        }
    }
    
    private(set) var operand2: Double? {
        didSet {
            if let operand2 {
                if oldValue != nil {
                    self.operand2 = Double(String(Int(result!)) + String(Int(operand2)))
                    result = self.operand2
                } else {
                    result = operand2
                }
            }
        }
    }
    
    private(set) var operand2Stored: Double?
    
    var isEnteringDecimalPart = false

    
    enum OperationType {
        case addition
        case subtraction
        case multiplication
        case division
    }

    struct MathOperation {
        private(set) var operand1: Double
        private(set) var operand2: Double
        private(set) var operationType: OperationType
    }
    
    init(result: Double? = nil, operand1: Double? = nil, operand2: Double? = nil) {
        self.result = result
        self.operand1 = operand1
        self.operand2 = operand2
    }
    
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
        
        postCalculationUpdates()
    }
    

    func add() {
        let mathOperation = MathOperation(operand1: self.operand1!, operand2: self.operand2!, operationType: .addition)
        performOperation(mathOperation)
    }
    
    func subtraction() {
        let mathOperation = MathOperation(operand1: self.operand1!, operand2: self.operand2!, operationType: .subtraction)
        performOperation(mathOperation)
    }

    func multiplication() {
        let mathOperation = MathOperation(operand1: self.operand1!, operand2: self.operand2!, operationType: .multiplication)
        performOperation(mathOperation)
    }

    func division() {
        let mathOperation = MathOperation(operand1: self.operand1!, operand2: self.operand2!, operationType: .division)
        performOperation(mathOperation)
    }
        
    func calculatePercentage(value: Double, percentage: Double) {
        performOperation(MathOperation(operand1: value, operand2: 100, operationType: .division))
        performOperation(MathOperation(operand1: result!, operand2: percentage, operationType: .multiplication))
    }
    
    func checkForCalculationInARow(operationOnHold: KeyAction?, operationType: KeyAction){
        if let _ = operand1, let _ =  operand2 {
                calculate(operationType: operationType)
        }
    }

    
    func calculate(operationType: KeyAction){
         
        if let operand2Stored, self.operand2 == nil {
            self.operand2 = operand2Stored
        }
        
        if self.operand1 == nil {
            if let _ = self.operand2 {
                self.operand1 = 0
                
            }
        }

        switch operationType {
        case .Add:
            self.add()

        case .Divide:
                if self.operand2! == 0 || self.operand2! == -0 {
                    self.operand1 = 0
                } else{
                   self.division()
                }

        case .Multiply:
            self.multiplication()
            
        case .Subtract:
            self.subtraction()

        default:
            print("default Calculate \(operationType)")
        }
    }
    
    func oppositeSign(){
        if let _ = operand2 {
            let operand2Copy = operand2!
            self.operand2 = nil
            self.operand2 = operand2Copy * -1
            
        } else {
            let operand1Copy = operand1!
            self.operand1 = nil
            self.operand1 = operand1Copy * -1
        }
    }
        
    func clearResult(){
        self.operand1 = nil
        self.operand2 = nil
        self.result = 0;
        resetDecimalMode()
    }
        
    func coma() {
        isEnteringDecimalPart = true
    }
    
    func setOperand(operandValue: Double, operandType: Operand) {
            switch operandType {
            case .first:
                if String(operand1 ?? 0).count < 9{
                    if isEnteringDecimalPart {
                        let isInteger = floor(operand1  ?? 0) == operand1 ?? 0
                        var operand1Copy: String
                        
                        if isInteger {
                            operand1Copy = String(Int(operand1 ?? 0))
                        } else {
                            operand1Copy = String(operand1 ?? 0)
                        }
                        
                        if operand1Copy.contains("."){
                            operand1Copy = operand1Copy + String(Int(operandValue))
                        } else {
                            operand1Copy = operand1Copy + "." + String(Int(operandValue))
                        }
                        
                        operand1 = nil
                        operand1 = Double(operand1Copy)
                    } else {
                        operand1 = operandValue
                    }
                    
                }
            case .second:
                if String(operand2 ?? 0).count < 9{
                    
                    if isEnteringDecimalPart {
                        let isInteger = floor(operand2  ?? 0) == operand2 ?? 0
                        var operand2Copy: String
                        
                        if isInteger {
                            operand2Copy = String(Int(operand2 ?? 0))
                        } else {
                            operand2Copy = String(operand2 ?? 0)
                        }
                        
                        if operand2Copy.contains("."){
                            operand2Copy = operand2Copy + String(Int(operandValue))
                        } else {
                            operand2Copy = operand2Copy + "." + String(Int(operandValue))
                        }
                        
                        operand2 = nil
                        operand2 = Double(operand2Copy)
                    } else {
                        operand2 = operandValue
                    }
                }
            }
       }
    
    func resetDecimalMode() {
        isEnteringDecimalPart = false
    }
    
    func postCalculationUpdates(){
        self.operand1 = nil
        self.operand1 = result
        self.operand2Stored = operand2
        self.operand2 = nil
    }

    
    func dropLast(){        
        if let result = self.result {
            var resultString = String(result)
            let isInteger = floor(result) == result
            var intResult: Int

            if isInteger {
                intResult = Int(result)
                resultString = String(intResult)
            } else {
                resultString = String(result)
            }
            
            if resultString.count > 1 {
                if (resultString.count == 2 && resultString.contains("-")){
                    self.result = 0
                } else {
                    self.result = Double(String(resultString.dropLast()))
                }
                

            }
            else if resultString.count == 1 {
                self.result = 0
            }
        }
    }
}
