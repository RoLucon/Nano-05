//
//  HomeViewController.swift
//  Nano-05
//
//  Created by Beatriz Sato on 26/02/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var saibaMaisButton: UIButton!
    @IBOutlet weak var lineChartView: UIView!
    
    @IBOutlet weak var whoTreatmentDataView: UIView!
    @IBOutlet weak var whoInfectedDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saibaMaisButton.layer.cornerRadius = 10
        lineChartView.layer.cornerRadius = 10
        whoTreatmentDataView.layer.cornerRadius = 10
        whoInfectedDataView.layer.cornerRadius = 10
    }

}
