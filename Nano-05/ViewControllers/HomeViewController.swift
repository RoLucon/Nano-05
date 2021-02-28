//
//  HomeViewController.swift
//  Nano-05
//
//  Created by Beatriz Sato on 26/02/21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var saibaMaisButton: UIButton!
    @IBOutlet weak var lineChartView: UIView!
    
    @IBOutlet weak var whoTreatmentDataView: UIView!
    @IBOutlet weak var whoInfectedDataView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // parte do rogério
    // falta tabID
    private var homeTab: Tab!
    let homeTabId = "1"
    private var tableViewHeight: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saibaMaisButton.layer.cornerRadius = 10
        lineChartView.layer.cornerRadius = 10
        whoTreatmentDataView.layer.cornerRadius = 10
        whoInfectedDataView.layer.cornerRadius = 10
        
        // Tab Item
        let auxTab: [Tab] = tab.filter { $0.id == 1}
        guard let homeTab = auxTab.first else { return }
        self.homeTab = homeTab
        
        // MARK: Table View
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        
        let line = UIView(frame: frame)
        
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")

    }
    
    //MARK: ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        tableView.reloadData()
        tableView.layoutIfNeeded()

        if let heightContraint = tableViewHeight {
            heightContraint.constant = tableView.contentSize.height
        } else {
            tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
            tableViewHeight?.isActive = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: row, animated: true)
        }
    }

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        cell.textLabel?.text = homeTab.listItens[indexPath.row].title

        cell.isAccessibilityElement = true

        if let hint = homeTab.listItens[indexPath.row].titleHint {
            cell.accessibilityHint = hint
        } else {
            cell.accessibilityHint = "Clique para ver mais sobre \(homeTab.listItens[indexPath.row].title)"
        }

        cell.accessibilityValue = "Botão \(indexPath.row) de \(homeTab.listItens.count)"
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = homeTabId + "\(indexPath.row)"
        let loadVC = PostViewController()

        guard let post = postById(Int(value)!) else {
            fatalError("Impossível redirecionar. Post não encontrado")
        }

        loadVC.setPost(post)

        loadVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(loadVC, animated: true)
    }
}
