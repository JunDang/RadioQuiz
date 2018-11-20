//
//  quizDB.swift
//  RadioQuiz
//
//  Created by Jun Dang on 2018-11-15.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import SQLite

enum Result<T, Error> {
    case Success(T)
    case Failure(Error)
}

enum QueryError: Error {
    case Unknown
    case Cannot_Select_From_SQLite
    case Data_Not_Exist
}

class QuizDB {
    
    static let instance = QuizDB()
    private let db: Connection?
    private let questions = Table("questions")
    private let id = Expression<String>("id")
    private let question = Expression<String>("question")
    private let answer = Expression<String>("answer")
    private let choiceA = Expression<String>("option_a")
    private let choiceB = Expression<String>("option_b")
    private let choiceC = Expression<String>("option_c")
    private let choiceD = Expression<String>("option_d")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            db = try Connection("\(path)/ham.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    func Query_100_Random_IDs(_ types: String) -> Result<[String], Error> {
        
        var random_100_IDs = [String]()
        if types == "basic" {
            do {
                let basiceQuestions = questions.filter(id.like("B%"))
                let basicIDs = try db!.prepare(basiceQuestions).map{$0[id]}
                random_100_IDs = basicIDs.sample(100)
            } catch {
                return Result<[String], Error>.Failure(QueryError.Cannot_Select_From_SQLite)
            }
        } else if types == "advanced" {
            do {
                let advancedQuestions = questions.filter(id.like("A%"))
                let advancedIDs = try db!.prepare(advancedQuestions).map{$0[id]}
                random_100_IDs = advancedIDs.sample(100)
            } catch {
                return Result<[String], Error>.Failure(QueryError.Cannot_Select_From_SQLite)
            }
        } else {
            return Result<[String], Error>.Failure(QueryError.Data_Not_Exist)
        }
        return Result<[String], Error>.Success(random_100_IDs)
    }
    
    func queryQuestion(_ questionID: String) -> Result<QuestionModel, Error> {
        var question: QuestionModel
        do {
            let selectedQuestion = questions.filter(id == questionID)
            question = try db!.prepare(selectedQuestion).map{QuestionModel(questionID: $0[id], question: $0[self.question], answer: $0[answer], choiceA: $0[choiceA],choiceB: $0[choiceB],choiceC: $0[choiceC],choiceD: $0[choiceD])}[0]
        } catch {
            return Result<QuestionModel, Error>.Failure(QueryError.Cannot_Select_From_SQLite)
        }
        return Result<QuestionModel, Error>.Success(question)
    }
}
