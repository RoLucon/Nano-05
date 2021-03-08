//
//  ViewController.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 18/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func nextView(_ sender: Any) {
        
        if let pvc = pageViewController {
            pvc.goToNextPage()
        }
    }
    
    @IBAction func previusView(_ sender: Any) {
        if let pvc = pageViewController {
            pvc.goToPreviousPage()
        }
    }
    
    @IBAction func finish(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        vc?.overrideUserInterfaceStyle = .light
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: {
            UserDefaults.standard.set(true, forKey: "firstAccess")
        })
    }
}

