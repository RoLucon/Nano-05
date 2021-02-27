//
//  UIViewController.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 23/02/21.
//

import UIKit

extension UIViewController {
    var safeGuide: UILayoutGuide { self.view.safeAreaLayoutGuide }
    
    func feedbackGenerator(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
