//
//  Models.swift
//  Calculator
//
//  Created by Suren Poghosyan on 08.08.23.
//

import Foundation


let keys = [
    ["title": "AC", "type": KeyType.SecondaryMathAction, "actionType": KeyAction.Clear],
    ["title": "+/-", "type": KeyType.SecondaryMathAction, "actionType": KeyAction.OppositeSign],
    ["title": "%", "type": KeyType.SecondaryMathAction, "actionType": KeyAction.Percent],
    ["title": "/", "type": KeyType.MathAction, "actionType": KeyAction.Divide],
    ["title": "7", "value": 7,  "type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": "8", "value": 8,"type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": "9", "value": 9,"type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": "x", "type": KeyType.MathAction, "actionType": KeyAction.Multiply],
    ["title": "4", "value": 4,"type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": "5", "value": 5,"type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": "6", "value": 6,"type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": "-", "type": KeyType.MathAction, "actionType": KeyAction.Subtract],
    ["title": "1", "value": 1,"type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": "2", "value": 2,"type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": "3", "value": 3,"type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": "+", "type": KeyType.MathAction, "actionType": KeyAction.Add],
    ["title": "0", "value": 0 ,"type": KeyType.NumberKey, "actionType": KeyAction.Number],
    ["title": ",","type": KeyType.NumberKey, "actionType": KeyAction.Coma],
    ["title": "=", "type": KeyType.MathAction, "actionType": KeyAction.Calculate]
]



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

