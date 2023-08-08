//
//  ViewController.swift
//  Calculator
//
//  Created by Suren Poghosyan on 05.08.23.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    var operand1: Double?
    var operand2: Double?
    var temporaryString: String? = "0"
    var operationOnHold: KeyAction?
    
    @IBOutlet weak var calculatorKeyboardCollectionView: UICollectionView!
    @IBOutlet weak var calculatorTextField: UITextField!
    @IBOutlet weak var calculatorStackView: UIStackView!
    @IBOutlet weak var calculatorView: UIView!

    
    var calculator = Calculator()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        calculatorTextField.text = "0"
        calculatorTextField.inputView = UIView()
        calculatorTextField.font = UIFont.systemFont(ofSize: calculatorKeyboardCollectionView.bounds.width / 100 * 25, weight: UIFont.Weight.thin)
        calculatorTextField.tintColor = UIColor.clear
        calculatorTextField.borderStyle = .none
        calculatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height / 4).isActive = true
        calculatorKeyboardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calculatorView.translatesAutoresizingMaskIntoConstraints = false
        calculatorStackView.translatesAutoresizingMaskIntoConstraints = false
        calculatorKeyboardCollectionView.dataSource = self
        calculatorKeyboardCollectionView.delegate = self
        calculatorKeyboardCollectionView.register(CalculatorKeyCell.self, forCellWithReuseIdentifier: "cell")
        calculatorTextField.delegate = self
        
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(onTextFieldLeftSwipe))
        swipeGestureRecognizerLeft.direction = .left
        calculatorTextField.addGestureRecognizer(swipeGestureRecognizerLeft)
     }
    
    @objc func onTextFieldLeftSwipe(){
        if temporaryString!.count > 0 {
            temporaryString!.removeLast()
        } else if(temporaryString!.count == 0){
            temporaryString! = "0"
        }
        calculatorTextField.text = temporaryString
    }

    
    func onMathActionClick(keyAction: KeyAction? = nil, keyType: KeyType? = nil){
        if let _ = keyAction, let _ = keyType {
            operand1 = Double(temporaryString!)
        }
        
        for subview in calculatorKeyboardCollectionView.subviews{
            if let cell = subview as? CalculatorKeyCell {
                if cell.type == .MathAction{
                    cell.label.textColor = .white
                    let color = getKeyColor(type: cell.type!)
                    cell.contentView.backgroundColor = color
                    cell.backgroundColor = color
                    operationOnHold = cell.keyAction
                }
            }
        }
    }
    
    func handleKeyActionClick(type: KeyAction, value: Int? = nil) {
        switch type {
        case .Percent:
            let valueToCast = Double(temporaryString!)
            if temporaryString! != "0" {
                calculator.calculatePercentage(value: valueToCast!, percentage: 1)
                temporaryString! = String(format: "%.2f", calculator.result!)
                calculatorTextField.text = temporaryString!
            }
            
        case .OppositeSign:
            let valueToCast = Double(temporaryString!)
            let isInteger = floor(valueToCast!) == valueToCast!
            if(isInteger){
                temporaryString! = String(Int(valueToCast!) * -1)
            } else {
                temporaryString! = String(valueToCast! * -1.0)
            }
            calculatorTextField.text = temporaryString!
            
        case .Coma:
            print("Coma")
            
        case .Clear:
            temporaryString = "0"
            operand1 = nil
            operand2 = nil
            operationOnHold = nil
            onMathActionClick()
            calculatorTextField.text = temporaryString
            
        case .Calculate:
            switch operationOnHold {
            case .Add:
                calculator.add(value1: operand1!, value2: operand2!)
                temporaryString! = String(calculator.result!)
            case .Divide:
                calculator.division(value1: operand1!, value2: operand2!)
                temporaryString! = String(calculator.result!)
            case .Multiply:
                calculator.multiplication(value1: operand1!, value2: operand2!)
                temporaryString! = String(calculator.result!)
            case .Subtract:
                calculator.subtraction(value1: operand1!, value2: operand2!)
                temporaryString! = String(calculator.result!)
            default:
                print("default")
            }
            
        case .Number:
            if temporaryString!.count < 9 {
                
                    
                    var valueString: String?
                    if let value = value{
                        valueString = String(value)
                        print(valueString!)
                        if let _ = operationOnHold {
                            temporaryString! = "0"
                            onMathActionClick()
                            self.operationOnHold = nil
                        }

                        
                        if let _ = operand1 {
                            if(temporaryString! == "0"){
                                temporaryString! = valueString!
                                operand2 = Double(temporaryString!)
                            } else {
                                temporaryString! += valueString!
                                operand2 = Double(temporaryString!)
                            }
                        } else {
                            if(temporaryString! == "0"){
                                temporaryString! = valueString!
                            } else {
                                temporaryString! += valueString!
                            }
                        }
                        calculatorTextField.text = temporaryString
                        print(temporaryString!)
                        
                        
                    }
                
            }
        default:
            print("default")
        }
    }
    
    
    func updateClearButtonText(){
        
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

extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalculatorKeyCell
        let item = keys[indexPath.row]
        let cellWidth = calculatorKeyboardCollectionView.bounds.width / 4 - 10
        let title = item["title"] as? String
        switch title {
            case "0":
                cell.cellHeight = cellWidth
                cell.cellWidth = (calculatorKeyboardCollectionView.bounds.width / 4) - 10
//            cell.cellWidth = (calculatorKeyboardCollectionView.bounds.width / 4) * 2 - 0.5
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


final class CalculatorKeyCell: UICollectionViewCell {
    var label: UILabel!
    var value: Int!
    var cellHeight: CGFloat!
    var keyAction: KeyAction!
    var type: KeyType!
    var onAction: ((_ actionType: KeyAction, _ value: Int?) -> Void)?
    var onMathAction: ((_ keyAction: KeyAction,_ keyType: KeyType) -> Void)?
    
    var cellWidth: CGFloat!{
        willSet {
            self.cellWidth = newValue
        }
        didSet {
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setup() {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(touched))
        recognizer.minimumPressDuration = 0.0
        addGestureRecognizer(recognizer)
        isUserInteractionEnabled = true
    
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: self.cellHeight / 2.5)
        label.textAlignment = .center
        contentView.layer.cornerRadius = cellHeight / 2
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentView.widthAnchor.constraint(equalToConstant: self.cellWidth),
            contentView.heightAnchor.constraint(equalToConstant: self.cellHeight),
        ])
    }
    
    @objc func touched(sender: UILongPressGestureRecognizer) {
        let oldColor = self.backgroundColor
        if type == .MathAction {
            if sender.state == .began {
                if keyAction == .Calculate {
                    print(keyAction)
                    onAction!(keyAction, nil)
                }
                onMathAction!(keyAction, type)
                contentView.backgroundColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1))
                label.textColor = .systemOrange
            } else if sender.state == .ended {
                if keyAction == .Calculate {
                    contentView.backgroundColor = oldColor
                    label.textColor = .white
                }
            }
        } else {
            if sender.state == .began {
                if let onAction = onAction, let value = value {
                    onAction(keyAction, value)
                } else {
                    onAction!(keyAction, nil)
                }

                contentView.backgroundColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 0.5))
            } else if sender.state == .ended {
                contentView.backgroundColor = oldColor
            }
        }
    }
}

