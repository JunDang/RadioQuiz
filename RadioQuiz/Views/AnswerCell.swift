//
//  AnswerCell.swift
//  RadioQuiz
//
//  Created by Jun Dang on 2018-11-08.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class AnswerCell: UITableViewCell {
    private let answerLbl = UILabel()
    private var didSetupConstraints = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
        setStyle()
        layoutView()
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if didSetupConstraints {
            super.updateConstraints()
            return
        }
        layoutView()
        super.updateConstraints()
        didSetupConstraints = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
}

private extension AnswerCell {
    
    func setup() {
        contentView.addSubview(answerLbl)
    }
    
    func layoutView() {
        
        constrain(answerLbl) {
            $0.top == $0.superview!.top + 2
            $0.bottom == $0.superview!.bottom - 2
            $0.left == $0.superview!.left + 2
            $0.right == $0.superview!.right - 2
        }
    }
    
    func setStyle() {
        self.backgroundColor = UIColor.white
        answerLbl.textColor = UIColor.black
        answerLbl.backgroundColor = UIColor.white
        answerLbl.font = UIFont(name: "HelveticaNeue", size: 25)
        answerLbl.sizeToFit()
    }
}

extension AnswerCell {
    
    func updateAnswerCell(){
        answerLbl.text = "a) electron flow"
    }
    
}

