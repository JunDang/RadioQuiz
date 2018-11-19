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
    private let scoreButton = UIButton(frame: CGRect.zero)
    private let timeButton = UIButton(frame: CGRect.zero)
    @objc private let nextQuestionButton = UIButton(frame: CGRect.zero)
    var random_100_ids:[String] = [""]
    var questionIndex = 1
    var questionModel: QuestionModel?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.white
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(AnswerCell.self, forCellReuseIdentifier: "AnswerCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        //tableView.register(QuestionHeader.self, forHeaderFooterViewReuseIdentifier: "QuestionHeader")
        tableView.separatorColor = UIColor(red: (224/255.0), green: (224/255.0), blue: (224/255.0), alpha: 1.0)
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.sectionHeaderHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 99
        tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView()
        setup()
        layoutView()
        style()
        render()
        let firstQuestionResult: Result<QuestionModel, Error> =  QuizDB.instance.queryQuestion(random_100_ids[0])
        switch firstQuestionResult {
            case .Success(let questionModel):
                self.questionModel = questionModel
            case .Failure(let error):
                print("display the error")
        }
          
         navigationItem.title = "Question " + "\(1)" + "/100"
        
   }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: AnswerCell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
            cell.answerLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 26)
            if let questionModel = questionModel {
                cell.answerLbl.text = questionModel.question
            }
            return cell
        } else if indexPath.row == 1 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            return cell
        } else {
          let cell: AnswerCell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
           var options: [(String, String)] = [("", "")]
           if let questionModel = questionModel {
               options = [("a", questionModel.choiceA), ("b", questionModel.choiceB), ("c", questionModel.choiceC), ("d", questionModel.choiceD)]
        }
           cell.answerLbl.text = options[indexPath.row - 2].0 + ". " + options[indexPath.row - 2].1
           return cell
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
        view.addSubview(tableView)
        view.addSubview(scoreButton)
        view.addSubview(timeButton)
        //view.addSubview(nextQuestionButton)
        let nextQuestionButtonItem = UIBarButtonItem(customView: nextQuestionButton)
        navigationItem.rightBarButtonItem = nextQuestionButtonItem
    }
    
    func layoutView() {
        constrain(tableView) {
            $0.bottom == $0.superview!.bottom
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
        }
        constrain(scoreButton) {
            $0.bottom == $0.superview!.bottom - 200
            $0.left == $0.superview!.left + 30
            $0.right == $0.superview!.right - 30
            //$0.width == 160
            $0.height == 60
        }
        constrain(timeButton, scoreButton) {
            $0.top == $1.bottom + 5
            $0.left == $0.superview!.left + 30
            $0.right == $0.superview!.right - 30
            $0.height == 60
        }
        constrain(nextQuestionButton/*, timeButton*/) {
            //$0.top == $1.bottom + 5
            //$0.left == $0.superview!.left + 30
            //$0.right == $0.superview!.right - 30
            $0.width == 100
            //$0.height == 60
        }
   }
    
    func style() {
        
        scoreButton.layer.borderColor = UIColor.lightBlue.cgColor
        //scoreLbl.backgroundColor = UIColor.lightBlue
        scoreButton.layer.borderWidth = 3
        scoreButton.layer.cornerRadius = 20
        scoreButton.backgroundColor = UIColor.lightBlue
        scoreButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        //scoreButton.sizeToFit()
        
        timeButton.layer.borderColor = UIColor.lightBlue.cgColor
        timeButton.backgroundColor = UIColor.lightBlue
        timeButton.layer.borderWidth = 3
        timeButton.layer.cornerRadius = 20
        timeButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        //timeButton.sizeToFit()
        
        nextQuestionButton.layer.borderColor = UIColor.lightBlue.cgColor
        //nextQuestionButton.backgroundColor = UIColor.lightBlue
        //nextQuestionButton.layer.borderWidth = 1
        //nextQuestionButton.layer.cornerRadius = 20
        nextQuestionButton.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 18)
    }
    
    func render() {
        scoreButton.setTitle("Score: 60/100", for: UIControl.State.normal)
        scoreButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        timeButton.setTitle("Time: 100 min", for: UIControl.State.normal)
        timeButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        nextQuestionButton.setTitle("> Next", for: UIControl.State.normal)
        //nextQuestionButton.addTarget(self, action: #selector(QuizTableViewController.bButtonPressed), for: .touchUpInside)
        nextQuestionButton.addTarget(self, action: #selector(QuizTableViewController.nextQuestionButtonPressed), for: .touchUpInside)
   
    }
      @objc func nextQuestionButtonPressed(sender: UIButton) {
         let questionResult: Result<QuestionModel, Error> =  QuizDB.instance.queryQuestion(random_100_ids[questionIndex])
         switch questionResult {
            case .Success(let questionModel):
                self.questionModel = questionModel
                tableView.reloadData()
            case .Failure(let error):
                 print("display the error")
         }
         questionIndex += 1
         navigationItem.title = "Question " + "\(questionIndex)" + "/100"
         if questionIndex >= 100 {
             nextQuestionButton.isEnabled = false
             print("you have finished 100 random questions, for restart please go back to the main page")
         }
       }
}
