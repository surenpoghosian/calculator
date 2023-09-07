//
//  CalculatorCollectionVeiwCell.swift
//  Calculator
//
//  Created by Suren Poghosyan on 06.09.23.
//

import UIKit


final public class CalculatorKeyCell: UICollectionViewCell {
    var label: UILabel!
    var value: Int!
    var cellHeight: CGFloat!
    var keyAction: KeyAction!
    var type: KeyType!
    var onAction: ((_ actionType: KeyAction, _ value: Int?, _ keyType: KeyType?) -> Void)?
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
                    onAction!(keyAction, nil, type)
                }
                onMathAction!(keyAction, type)
                contentView.backgroundColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 0.7))
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
                    onAction(keyAction, value, nil)
                } else {
                    onAction!(keyAction, nil, nil)
                }
                contentView.backgroundColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 0.5))
            } else if sender.state == .ended {
                contentView.backgroundColor = oldColor
            }
        }
    }
}

