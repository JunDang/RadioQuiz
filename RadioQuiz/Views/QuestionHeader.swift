//
//  QuestionHeader.swift
//  RadioQuiz
//
//  Created by Jun Dang on 2018-11-08.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class QuestionHeader: UITableViewHeaderFooterView {
    private let questionLbl = UILabel()
    private var didSetupConstraints = false
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
}

private extension QuestionHeader {
    
    func setup() {
        contentView.addSubview(questionLbl)
    }
    
    func layoutView() {
        constrain(questionLbl) {
            $0.left == $0.superview!.left + 2
            $0.right == $0.superview!.right - 2
            //$0.top == $0.superview!.top + 2
            //$0.bottom == $0.superview!.bottom - 2
        }
    }
    
    func setStyle() {
        self.contentView.backgroundColor = UIColor.lighterGray
        questionLbl.textColor = UIColor.black
        questionLbl.backgroundColor = UIColor.lighterGray
        questionLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 26)
        questionLbl.numberOfLines = 5
        questionLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        questionLbl.sizeToFit()
    }
}

extension QuestionHeader {
    
    func updateQuestionHeaderCell(with questionModel: QuestionModel){
        questionLbl.text = questionModel.question
    }
    
}

