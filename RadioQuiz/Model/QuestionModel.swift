//
//  QuestionModel.swift
//  RadioQuiz
//
//  Created by Jun Dang on 2018-11-13.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

class QuestionModel {
    
    var questionID: String = ""
    var question: String = ""
    var answer: String = ""
    var choiceA: String = ""
    var choiceB: String = ""
    var choiceC: String = ""
    var choiceD: String = ""

    init(questionID: String, question: String, answer: String, choiceA: String, choiceB: String, choiceC: String, choiceD: String) {
         self.questionID = questionID
         self.question = question
         self.answer = answer
         self.choiceA = choiceA
         self.choiceB = choiceB
         self.choiceC = choiceC
         self.choiceD = choiceD
 
    }
}
