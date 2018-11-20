//
//  Message.swift
//  RadioQuiz
//
//  Created by Jun Dang on 2018-11-19.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import SwiftMessages


public extension UIViewController {
    
    func disPlayInfo(_ title: String, message: String) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: title, body: message)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .center
        infoConfig.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func disPlayError(_ errorMessage: String) {
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: errorMessage)
        error.button?.setTitle("Stop", for: .normal)
        SwiftMessages.show(view: error)
    }
    
    func displayMessage(_ title: String, userMessage: String, actionTitle: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: userMessage, preferredStyle: .alert)
        let action = UIAlertAction(
            title: actionTitle,
            style: .default,
            handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
