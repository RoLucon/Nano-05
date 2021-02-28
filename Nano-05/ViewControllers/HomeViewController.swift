//
//  HomeViewController.swift
//  Nano-05
//
//  Created by Beatriz Sato on 26/02/21.
//

import UIKit
import Charts

class HomeViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var saibaMaisButton: UIButton!
    
    // view do gráfico
    @IBOutlet weak var lineChartView: LineChartView!
    
    // view dos números das apis
    @IBOutlet weak var whoTreatmentDataView: UIView!
    @IBOutlet weak var whoInfectedDataView: UIView!
    
    // view das fontes
    @IBOutlet weak var tableView: UITableView!
    
    // Configuração da TabItem
    private var homeTab: Tab!
    let homeTabId = "1"
    private var tableViewHeight: NSLayoutConstraint?
    
    // requisição API
//    var whoDataLoader = WhoDataLoader()
    var deaths = [Double]()
    var infected = [Double]()
    var years = [Int]()
    
    var lineChart = WhoLineChart()
        
    private let deathURL = "https://ghoapi.azureedge.net/api/HIV_0000000006?$filter=SpatialDim%20eq%20%27BRA%27"
    private let infectedURL = "https://ghoapi.azureedge.net/api/HIV_0000000001?$filter=SpatialDim%20eq%20%27BRA%27"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saibaMaisButton.layer.cornerRadius = 10
        lineChartView.layer.cornerRadius = 10
        whoTreatmentDataView.layer.cornerRadius = 10
        whoInfectedDataView.layer.cornerRadius = 10
        
        // Configuração do TabItem pra receber o JSON
        let auxTab: [Tab] = tab.filter { $0.id == 1}
        guard let homeTab = auxTab.first else { return }
        self.homeTab = homeTab
        
        // MARK: Table View Config
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
        
        apiRequest()
        styleChart()

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
    
    func apiRequest() {
        // faz a requisição e pega só o número de morte e ano
        requestData(url: deathURL) { (whoDeathsData) in
            self.getDeathsValue(whoData: whoDeathsData)
        }
        
        // faz a requisição, pega o número de infectados e passa para o gráfico
        requestData(url: infectedURL) {(whoInfectedData) in
            self.getInfectedValue(whoData: whoInfectedData)
            
            // cria a instância do gráfico
            self.lineChart = WhoLineChart(years: self.years, deaths: self.deaths, infected: self.infected, deathColor: .red, infectedColor: .blue)
            
            // atualiza a view do gráfico
            self.lineChartView.data = self.lineChart.data
        }
    }
    
    func styleChart() {
        // retira a label da direita do eixo y
        lineChartView.rightAxis.enabled = false
        
        // anos embaixo ao invés de em cima
        lineChartView.xAxis.labelPosition = .bottom
        
        // tamanho e cor das labels eixo x
        let xAxis = lineChartView.xAxis
        xAxis.labelFont = .boldSystemFont(ofSize: 10)
        
        // eixo y
        lineChartView.leftAxis.labelFont = .boldSystemFont(ofSize: 10)
    }
    
    // método que separa os números dos dados da api
    func getDeathsValue(whoData: [WhoData]) {
        // de 3 em 3 anos
        for i in stride(from: 1, to: whoData.count, by: 3) {
            let index = i
            
            deaths.append(whoData[index].NumericValue)
            years.append(whoData[index].TimeDim)
        }
    }
    
    func getInfectedValue(whoData: [WhoData]) {
        // de 3 em 3 anos
        for i in stride(from: 1, to: whoData.count, by: 3) {
            let index = i
            
            infected.append(whoData[index].NumericValue)
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
            cell.accessibilityHint = "Clique para ler mais sobre \(homeTab.listItens[indexPath.row].title)"
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
