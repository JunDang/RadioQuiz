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
    let answerLbl = UILabel()
    let markImageView = UIImageView(frame: CGRect.zero)
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
        contentView.addSubview(markImageView)
    }
    
    func layoutView() {
        
        constrain(answerLbl) {
            $0.top == $0.superview!.top + 2
            $0.bottom == $0.superview!.bottom - 2
            $0.left == $0.superview!.left + 2
            $0.right == $0.superview!.right - 2
        }
        constrain(markImageView) {
            $0.right == $0.superview!.right - 30
            $0.centerY == $0.superview!.centerY
            $0.width == 55
            $0.height == 55
        }
    }
    
    func setStyle() {
        self.backgroundColor = UIColor.white
        answerLbl.textColor = UIColor.black
        answerLbl.backgroundColor = UIColor.white
        answerLbl.font = UIFont(name: "HelveticaNeue", size: 22)
        answerLbl.numberOfLines = 10
        answerLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        answerLbl.sizeToFit()
    }
}

/*extension AnswerCell {
    
    func updateAnswerCell(with options: [String]){
        let letters: [String] = ["a)", "b)", "c)", "d)"]
        for i in 0..<options.count {
            answerLbl.text = "\(letters[i]): \(options[i])"
        }
     }
    
}*/

