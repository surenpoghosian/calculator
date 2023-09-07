//
//  Models.swift
//  Calculator
//
//  Created by Suren Poghosyan on 08.08.23.
//



enum KeyType{
    case MathAction
    case SecondaryMathAction
    case NumberKey
    case ThirdTypeKey
}

enum KeyAction{
    case Add
    case Subtract
    case Divide
    case Multiply
    case OppositeSign
    case Clear
    case Percent
    case Calculate
    case Coma
    case Number
}

enum Operand {
    case first
    case second
}

enum ClearButtonState {
    case ac
    case c
}
