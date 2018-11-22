//
//  QuizTableViewController.swift
//  RadioQuiz
//
//  Created by Jun Dang on 2018-11-07.
//  Copyright © 2018 Jun Dang. All rights reserved.
//


import UIKit
import Cartography

class QuizTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = UITableView(frame: CGRect.zero)
    private let nextQuestionButton = UIButton(frame: CGRect.zero)
    var questionTypes: String = ""
    private var random_100_ids:[String] = [""]
    private var questionIndex = 0
    private var questionModel: QuestionModel = QuestionModel(questionID: "", question: "", answer: "", choiceA: "", choiceB: "", choiceC: "", choiceD: "")
    private var scores: Int = 0
    private var markImageView: UIImageView = UIImageView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.white
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(AnswerCell.self, forCellReuseIdentifier: "answerCell")
        tableView.separatorColor = UIColor(red: (224/255.0), green: (224/255.0), blue: (224/255.0), alpha: 1.0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 99
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView()
        
        setup()
        layoutView()
        style()
        render()
        random_100_ids = get_100_Random_ids(questionTypes)
        self.questionModel = loadQuestion(random_100_ids[questionIndex])
        navigationItem.title = "Question " + "\(1)" + "/100"
     }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: AnswerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerCell
            cell.answerLbl.text = questionModel.question
            cell.answerLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            return cell
        } else {
           let cell: AnswerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerCell
           let options: [(String, String)] = [("a", questionModel.choiceA), ("b", questionModel.choiceB), ("c", questionModel.choiceC), ("d", questionModel.choiceD)]
           cell.answerLbl.text = options[indexPath.row - 1].0 + ". " + options[indexPath.row - 1].1
           return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chooseAnswer: String = ""
        if indexPath.row == 0 {
            disPlayInfo("Stop", message: "You cannot choose the question itself")
        } else if indexPath.row == 1 {
            chooseAnswer = "A"
        } else if indexPath.row == 2 {
            chooseAnswer = "B"
        } else if indexPath.row == 3 {
            chooseAnswer = "C"
        } else {
            chooseAnswer = "D"
        }
        if questionModel.answer == chooseAnswer {
            markImageView.image = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.markImageView.image = UIImage(named: "greencheckmark")
            }
            scores += 1
        } else {
            markImageView.image = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.markImageView.image = UIImage(named: "redcrossmark")
            }
            scores += 0
        }
    }
}

extension QuizTableViewController {
    func setup() {
        tableView.addSubview(markImageView)
        view.addSubview(tableView)
        view.addSubview(nextQuestionButton)
    }
    
    func layoutView() {
        constrain(nextQuestionButton) {
            $0.bottom == $0.superview!.bottom - 20
            $0.left == $0.superview!.left + 30
            $0.right == $0.superview!.right - 30
            $0.height == 50
            $0.centerX == $0.superview!.centerX
        }
        constrain(tableView, nextQuestionButton) {
            $0.bottom == $1.top - 5
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
        }
        constrain(markImageView) {
            $0.centerX == $0.superview!.centerX
            $0.centerY == $0.superview!.centerY - 100
        }
    }
    
    func style() {
        
        nextQuestionButton.layer.borderColor = UIColor.lightBlue.cgColor
        nextQuestionButton.backgroundColor = UIColor.lightBlue
        nextQuestionButton.layer.borderWidth = 3
        nextQuestionButton.layer.cornerRadius = 20
        nextQuestionButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 23)
        nextQuestionButton.sizeToFit()
    }
    
    func render() {
        nextQuestionButton.setTitle("Next Question", for: UIControl.State.normal)
        nextQuestionButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        nextQuestionButton.addTarget(self, action: #selector(QuizTableViewController.nextQuestionButtonPressed), for: .touchUpInside)
    }
    @objc func nextQuestionButtonPressed(sender: UIButton) {
        markImageView.image = nil
        questionIndex += 1
        if questionIndex < 100 {
            self.questionModel = loadQuestion(random_100_ids[questionIndex])
            navigationItem.title = "Question " + "\(questionIndex + 1)" + "/100"
        } else {
            nextQuestionButton.isEnabled = false
            displayMessage("Your score is \(scores)", userMessage: "Please load another 100 random questions.", actionTitle: "Restart", handler: {(alert: UIAlertAction!) in
                self.random_100_ids = self.get_100_Random_ids(self.questionTypes)
                self.questionIndex = 0
                self.questionModel = self.loadQuestion(self.random_100_ids[self.questionIndex])
                self.navigationItem.title = "Question " + "\(1)" + "/100"
                self.nextQuestionButton.isEnabled = true
            })
        }
    }
    
    func get_100_Random_ids(_ questionTypes: String) -> [String] {
        let random_100_ids_Result:Result<[String], Error> = QuizDB.instance.Query_100_Random_IDs(questionTypes)
        switch random_100_ids_Result {
        case .Success(let random_100_ids):
            self.random_100_ids = random_100_ids
        case .Failure(let error):
            disPlayError("\(error)")
        }
        return random_100_ids
    }
    
    func loadQuestion(_ id: String) -> QuestionModel {
        let questionResult: Result<QuestionModel, Error> =  QuizDB.instance.queryQuestion(id)
        switch questionResult {
        case .Success(let queriedQuestionModel):
            questionModel = queriedQuestionModel
            tableView.reloadData()
        case .Failure(let error):
            disPlayError("\(error)")
        }
        return questionModel
    }
 }
