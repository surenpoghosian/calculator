//
//  ViewController.swift
//  Calculator
//
//  Created by Suren Poghosyan on 05.08.23.
//

import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate {
    private(set) var operationOnHold: KeyAction?
    private(set) var operationOnHoldTemporary: KeyAction?
    
    @IBOutlet weak var calculatorKeyboardCollectionView: UICollectionView!
    @IBOutlet weak var calculatorTextField: UITextField!
    @IBOutlet weak var calculatorStackView: UIStackView!
    @IBOutlet weak var calculatorView: UIView!
    
    var calculator = Calculator()
    
    let keys: [[String : Any]] = [
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        calculatorTextField.text = "0"
        calculatorTextField.inputView = UIView()
        calculatorTextField.font = UIFont.systemFont(ofSize: calculatorKeyboardCollectionView.bounds.width / 100 * 25, weight: UIFont.Weight.thin)
        calculatorTextField.tintColor = UIColor.clear
        calculatorTextField.borderStyle = .none
        
        calculatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height / 4.5).isActive = true
        
        calculatorKeyboardCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height / 2.6).isActive = true
        
        calculatorKeyboardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calculatorView.translatesAutoresizingMaskIntoConstraints = false
        calculatorStackView.translatesAutoresizingMaskIntoConstraints = false
        
        calculatorKeyboardCollectionView.dataSource = self
        calculatorKeyboardCollectionView.delegate = self
        calculatorKeyboardCollectionView.register(CalculatorKeyCell.self, forCellWithReuseIdentifier: "cell")
        
        calculatorTextField.delegate = self
        
        calculatorKeyboardCollectionView.isScrollEnabled = false
        
        let swipeGestureRecognizerHorizontal = UISwipeGestureRecognizer(target: self, action: #selector(onTextFieldHorizontalSwipe))
        swipeGestureRecognizerHorizontal.direction = [.left, .right]
        calculatorTextField.addGestureRecognizer(swipeGestureRecognizerHorizontal)
    }
    
    @objc func onTextFieldHorizontalSwipe(){
        calculator.dropLast()
        if let result = calculator.result {
            updateResult()
            if result == 0 {
                updateClearButtonText(set: .ac)
            }
        }
    }
    
    
    func onMathActionClick(keyAction: KeyAction? = nil, keyType: KeyType? = nil){
        if let keyAction = keyAction, let _ = keyType {
            if keyAction != .Calculate {
                
                self.operationOnHoldTemporary = keyAction
                self.operationOnHold = keyAction
                
                self.calculator.checkForCalculationInARow(operationOnHold: operationOnHold, operationType: keyAction)
                self.updateResult()

            } else {
                self.operationOnHoldTemporary = keyAction
            }
            calculator.resetDecimalMode()
        }
        
        
        for subview in calculatorKeyboardCollectionView.subviews{
            if let cell = subview as? CalculatorKeyCell {
                if cell.type == .MathAction{
                    cell.label.textColor = .white
                    let color = getKeyColor(type: cell.type!)
                    cell.contentView.backgroundColor = color
                    cell.backgroundColor = color
                }
            }
        }
    }

    func handleKeyActionClick(type: KeyAction, value: Int? = nil, keyType: KeyType? = nil) {
        switch type {
        case .Percent:
            calculator.calculatePercentage(value: calculator.result!, percentage: 1)
            
        case .OppositeSign:
            calculator.oppositeSign()
            
        case .Coma:
            onComaPress()
            calculator.coma()
            
        case .Clear:
            updateClearButtonText(set: .ac)
            operationOnHoldTemporary = nil
            calculator.clearResult()
            onMathActionClick()
            
        case .Calculate:
            if let operationOnHold{
                calculator.calculate(operationType: operationOnHold)
            }
            
        case .Number:
            updateClearButtonText(set: .c)
            if let _ = operationOnHoldTemporary {
                calculator.setOperand(operandValue: Double(value!), operandType: .second)
                onMathActionClick()
            } else {
                calculator.setOperand(operandValue: Double(value!), operandType: .first)
            }
            
            
        default:
            break
        }
        
        if type != .Coma {
            updateResult()
        }
    }
    
    
    func updateClearButtonText(set newState: ClearButtonState){
        for subview in calculatorKeyboardCollectionView.subviews{
            if let cell = subview as? CalculatorKeyCell {
                if cell.label.text == "AC" || cell.label.text == "C" {
                    switch newState {
                    case .ac:
                        cell.label.text = "AC"
                    case .c:
                        cell.label.text = "C"
                    }
                    
                }
            }
        }
    }
    
    func updateResult(){
        if let result = calculator.result {
            let isInteger = floor(result) == result
            var resultToShow: String
            
            if isInteger {
                resultToShow = String(Int(result))
            } else {
                resultToShow = String(result)
            }
            
            calculatorTextField.text = String(resultToShow)
        }
    }
    
    func onComaPress(){
        let label = calculatorTextField.text
        let includesComa = label?.contains(".")

        if includesComa! == false {
            let newValue = label! + "."
            calculatorTextField.text = newValue
        }
        


    }
    
    func getKeyColor(type: KeyType) -> UIColor {
        switch type {
        case .MathAction:
            return UIColor.systemOrange
        case .SecondaryMathAction:
            return UIColor.gray
        case .NumberKey:
            return UIColor.systemGray4
        case .ThirdTypeKey:
            return UIColor.white
        }
    }
    
    
}

extension CalculatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}

extension CalculatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalculatorKeyCell
        let item = keys[indexPath.row]
        let cellWidth = calculatorKeyboardCollectionView.bounds.width / 4 - 10
        let title = item["title"] as? String
        
        switch title {
        case "0":
            cell.cellHeight = cellWidth
            cell.cellWidth = (calculatorKeyboardCollectionView.bounds.width / 4) * 2 - 0.5
            cell.label.textAlignment = .left
            cell.label.text = item["title"] as? String
            
            let leftPadding = cellWidth / 2
            
            if let text = cell.label.text{
                let font = UIFont.systemFont(ofSize: cellWidth / 2.5)
                let fontAttributes = [NSAttributedString.Key.font: font]
                let size = (text as String).size(withAttributes: fontAttributes)
                cell.label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: leftPadding - size.width / 2).isActive = true
            }
            
        default:
            cell.cellHeight = cellWidth
            cell.cellWidth = cellWidth
            cell.label.text = item["title"] as? String
            cell.label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
        }
        
        let type = item["type"] as? KeyType
        let action = item["actionType"] as? KeyAction
        let value = item["value"] as? Int
        
        cell.onMathAction = self.onMathActionClick
        cell.keyAction = action
        cell.onAction = handleKeyActionClick
        
        if let value = value {
            cell.value = value
        }
        
        cell.type = type
        cell.label.textColor = .white
        cell.backgroundColor =  self.getKeyColor(type: type!)
        let radius = cellWidth
        cell.layer.cornerRadius = radius / 2
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
