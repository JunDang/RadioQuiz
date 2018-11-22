//
//  CoverPageViewController.swift
//  RadioQuiz
//
//  Created by Jun Dang on 2018-11-06.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class CoverPageViewController: UIViewController {
    
    let titleLbl = UILabel(frame: CGRect.zero)
    let bButton = UIButton(frame: CGRect.zero)
    let aButton = UIButton(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        style()
        render()
        navigationController?.navigationBar.tintColor = UIColor.white
        let backItem = UIBarButtonItem()
        backItem.title = "Main Page"
        navigationItem.backBarButtonItem = backItem
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func bButtonPressed(sender: UIButton) {
        let quizTableViewController = QuizTableViewController()
        quizTableViewController.questionTypes = "basic"
        navigationController?.pushViewController(quizTableViewController, animated: true)
    }
    
    @objc func aButtonPressed(sender: UIButton) {
        let quizTableViewController = QuizTableViewController()
        quizTableViewController.questionTypes = "advanced"
        navigationController?.pushViewController(quizTableViewController, animated: true)
    }
}

extension CoverPageViewController {
    func setup() {
        self.view.addSubview(titleLbl)
        self.view.addSubview(bButton)
        self.view.addSubview(aButton)
    }
    
    func layoutView() {
        constrain(titleLbl) {
            $0.top == $0.superview!.top + 150
            $0.centerX == $0.superview!.centerX
            $0.left == $0.superview!.left + 2
            $0.right == $0.superview!.right - 2
        }
        constrain(aButton) {
            $0.centerX == $0.superview!.centerX
            $0.left == $0.superview!.left + 60
            $0.right == $0.superview!.right - 60
            $0.height == 55
            $0.bottom == $0.superview!.bottom - 20
        }
        constrain(bButton, aButton) {
            $0.bottom == $1.top - 5
            $0.left == $1.left
            $0.right == $1.right
            $0.height == 55
        }
    }
    
    func style() {
        self.view.backgroundColor = UIColor.lightBlue
            
        titleLbl.backgroundColor = UIColor.clear
        titleLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        titleLbl.textColor = UIColor.white
        titleLbl.textAlignment = .center
        titleLbl.numberOfLines = 3
        titleLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLbl.sizeToFit()
              
        bButton.layer.borderColor = UIColor.white.cgColor
        bButton.layer.borderWidth = 1
        bButton.layer.cornerRadius = 5
        bButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        
        aButton.layer.borderColor = UIColor.white.cgColor
        aButton.layer.borderWidth = 1
        aButton.layer.cornerRadius = 5
        aButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
    }
    
    func render() {
        aButton.setTitle("Advanced", for: UIControl.State.normal)
        aButton.addTarget(self, action: #selector(CoverPageViewController.aButtonPressed), for: .touchUpInside)
        bButton.setTitle("Basic", for: UIControl.State.normal)
        bButton.addTarget(self, action: #selector(CoverPageViewController.bButtonPressed), for: .touchUpInside)
        titleLbl.text = "Canadian Amateur Radio Exam"
    }
}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        let coverPageViewController = CoverPageViewController()
        return coverPageViewController.preferredStatusBarStyle
    }
}
