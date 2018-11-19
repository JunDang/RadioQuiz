//
//  QuizTableViewController.swift
//  RadioQuiz
//
//  Created by Jun Dang on 2018-11-07.
//  Copyright © 2018 Jun Dang. All rights reserved.
//


import UIKit
import Cartography
import SwiftMessages


class QuizTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = UITableView(frame: CGRect.zero)
    private let restartButton = UIButton(frame: CGRect.zero)
    private let timeButton = UIButton(frame: CGRect.zero)
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        tableView.register(QuestionCell.self, forCellReuseIdentifier: "questionCell")
        //tableView.register(QuestionHeader.self, forHeaderFooterViewReuseIdentifier: "QuestionHeader")
        tableView.separatorColor = UIColor(red: (224/255.0), green: (224/255.0), blue: (224/255.0), alpha: 1.0)
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.sectionHeaderHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 99
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView()
        setup()
        layoutView()
        style()
        render()
        random_100_ids = get_100_Random_ids(questionTypes)
        loadQuestion(random_100_ids[questionIndex])
        navigationItem.title = "Question " + "\(1)" + "/100"
        if questionTypes == "basic" {
            disPlayInfo("Basic", message: "100 random basic level questions")
        } else if questionTypes == "advanced" {
            disPlayInfo("Advanced", message: "100 random advanced level questions")
        } else {
            disPlayInfo("Quiz Level not Choosed", message: "Please choose from Basic or Advanced")
        }
       
   }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: AnswerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerCell
            cell.answerLbl.text = questionModel.question
                cell.answerLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            return cell
        } else if indexPath.row == 1 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            return cell
        } else {
           let cell: AnswerCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerCell
           let options: [(String, String)] = [("a", questionModel.choiceA), ("b", questionModel.choiceB), ("c", questionModel.choiceC), ("d", questionModel.choiceD)]
           cell.answerLbl.text = options[indexPath.row - 2].0 + ". " + options[indexPath.row - 2].1
           return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chooseAnswer: String = ""
        if indexPath.row == 0 {
            disPlayInfo("Stop", message: "You cannot choose question itself")
        } else if indexPath.row == 2 {
            chooseAnswer = "A"
        } else if indexPath.row == 3 {
            chooseAnswer = "B"
        } else if indexPath.row == 4 {
            chooseAnswer = "C"
        } else {
            chooseAnswer = "D"
        }
        if questionModel.answer == chooseAnswer {
            markImageView.image = UIImage(named: "redcheckmark50")
            scores += 1
        } else {
            markImageView.image = UIImage(named: "redcrossmark50")
        }
        
    
    }
  /*  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QuestionHeader") as! QuestionHeader
        if let questionModel = questionModel {
            headerCell.updateQuestionHeaderCell(with: questionModel)
        }
        return headerCell
    }*/
  /*  override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let header = tableView.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            header.frame.size.height = newSize.height
        }
    }*/
    
}

extension QuizTableViewController {
    func setup() {
        tableView.addSubview(markImageView)
        view.addSubview(tableView)
        view.addSubview(restartButton)
        view.addSubview(timeButton)
        view.addSubview(nextQuestionButton)
        let timeButtonItem = UIBarButtonItem(customView: timeButton)
        navigationItem.rightBarButtonItem = timeButtonItem
    }
    
    func layoutView() {
        constrain(tableView) {
            $0.bottom == $0.superview!.bottom
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
        }
        constrain(markImageView) {
            $0.centerX == $0.superview!.centerX
            $0.centerY == $0.superview!.centerY
        }
        constrain(restartButton) {
            $0.bottom == $0.superview!.bottom - 30
            //$0.left == $0.superview!.left + 30
            //$0.right == $0.superview!.right - 30
            $0.width == 160
            $0.height == 60
            $0.centerX == $0.superview!.centerX
        }
        constrain(nextQuestionButton, restartButton) {
            $0.bottom == $1.top - 5
            //$0.left == $0.superview!.left + 30
            //$0.right == $0.superview!.right - 30
            $0.width == 160
            $0.height == 60
            $0.centerX == $0.superview!.centerX
        }
      /*  constrain(timeButton/*, timeButton*/) {
            //$0.top == $1.bottom + 5
            //$0.left == $0.superview!.left + 30
            //$0.right == $0.superview!.right - 30
            //$0.width == 100
           // $0.height == 60
        }*/
   }
    
    func style() {
        
        restartButton.layer.borderColor = UIColor.lightBlue.cgColor
        //scoreLbl.backgroundColor = UIColor.lightBlue
        restartButton.layer.borderWidth = 3
        restartButton.layer.cornerRadius = 20
        restartButton.backgroundColor = UIColor.lightBlue
        restartButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        restartButton.sizeToFit()
        
        nextQuestionButton.layer.borderColor = UIColor.lightBlue.cgColor
        nextQuestionButton.backgroundColor = UIColor.lightBlue
        nextQuestionButton.layer.borderWidth = 3
        nextQuestionButton.layer.cornerRadius = 20
        nextQuestionButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        nextQuestionButton.sizeToFit()
        
        timeButton.layer.borderColor = UIColor.lightBlue.cgColor
        //nextQuestionButton.backgroundColor = UIColor.lightBlue
        //nextQuestionButton.layer.borderWidth = 1
        //nextQuestionButton.layer.cornerRadius = 20
        timeButton.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 18)
    }
    
    func render() {
        nextQuestionButton.setTitle("Next Question", for: UIControl.State.normal)
        nextQuestionButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        restartButton.setTitle("Restart", for: UIControl.State.normal)
        restartButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        timeButton.setTitle("100 min", for: UIControl.State.normal)
        restartButton.addTarget(self, action: #selector(QuizTableViewController.restartButtonPressed), for: .touchUpInside)
        nextQuestionButton.addTarget(self, action: #selector(QuizTableViewController.nextQuestionButtonPressed), for: .touchUpInside)
   
    }
      @objc func nextQuestionButtonPressed(sender: UIButton) {
        markImageView.image = nil
        questionIndex += 1
        loadQuestion(random_100_ids[questionIndex])
        
         navigationItem.title = "Question " + "\(questionIndex+1)" + "/100"
         if questionIndex >= 99 {
             nextQuestionButton.isEnabled = false
            displayMessage("your score is \(scores)", userMessage: "Finished 100 questions", handler: nil)
         }
        
       }
    @objc func restartButtonPressed(sender: UIButton) {
        random_100_ids = get_100_Random_ids(questionTypes)
        loadQuestion(random_100_ids[questionIndex])
        navigationItem.title = "Question " + "\(1)" + "/100"
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
