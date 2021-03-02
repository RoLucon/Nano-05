//
//  HomeViewController.swift
//  Nano-05
//
//  Created by Beatriz Sato on 26/02/21.
//

import UIKit
import Charts

class HomeViewController: UIViewController, UITableViewDelegate, ChartViewDelegate {

    @IBOutlet weak var saibaMaisButton: UIButton!
    
    // view do gráfico
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var outsideChartView: UIView!
    
    // view dos números das apis
    @IBOutlet weak var whoTreatmentDataView: UIView!
    @IBOutlet weak var whoInfectedDataView: UIView!
    @IBOutlet weak var treatmentsNumber: UITextView!
    @IBOutlet weak var infectedNumber: UITextView!
    
    // view das fontes
    @IBOutlet weak var tableView: UITableView!
    
    // Configuração da TabItem
    private var homeTab: Tab!
    let homeTabId = "1"
    private var tableViewHeight: NSLayoutConstraint?
    
    // requisição API
    var deaths = [Double]()
    var hivPositive = [Double]()
    var years = [Int]()
            
    private let deathURL = "https://ghoapi.azureedge.net/api/HIV_0000000006?$filter=SpatialDim%20eq%20%27BRA%27"
    private let infectedURL = "https://ghoapi.azureedge.net/api/HIV_0000000001?$filter=SpatialDim%20eq%20%27BRA%27"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiRequest()

        // Do any additional setup after loading the view.
        saibaMaisButton.layer.cornerRadius = 10
        outsideChartView.layer.cornerRadius = 10
        whoTreatmentDataView.layer.cornerRadius = 10
        whoInfectedDataView.layer.cornerRadius = 10
        
        // Configuração do TabItem pra receber o JSON
        let auxTab: [Tab] = tab.filter { $0.id == 1}
        guard let homeTab = auxTab.first else { return }
        self.homeTab = homeTab
        
        // Configuração da TableView
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
        
        
        // MARK: Configuração gráfico
        lineChartView.delegate = self
        lineChartView.chartDescription.enabled = false
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = true
        
        let legend = lineChartView.legend
        legend.form = .line
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.drawInside = false
        
        let xAxis = lineChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let rightAxis = lineChartView.rightAxis
        rightAxis.enabled = false
                
        lineChartView.animate(xAxisDuration: 2.5)
        
        msApiRequest()
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
    
    // MARK: Requisição API + Gráfico
    func apiRequest() {
        // faz a requisição e pega só o número de morte e ano
        requestWhoData(url: deathURL) { (whoDeathsData) in
            self.deaths = getDeathsValue(whoData: whoDeathsData)
            self.years = getYearsValue(whoData: whoDeathsData)
        }
        
        // faz a requisição, pega o número de infectados e passa tudo para o gráfico
        requestWhoData(url: infectedURL) {(whoInfectedData) in
            self.hivPositive = getInfectedValue(whoData: whoInfectedData)
            
            self.setChartData(x1: self.generateDataEntry(data: self.deaths, years: self.years), x2: self.generateDataEntry(data: self.hivPositive, years: self.years), label1: "Número de mortes", label2: "Número de soropositivos")
            self.infectedNumber.text = "\(Int(self.hivPositive.last!))"
        }
    }
    
    // x years, y morte e infectado
    func generateDataEntry(data: [Double], years: [Int]) -> [ChartDataEntry] {
        let entry = (0..<years.count).map { (i) ->
            ChartDataEntry in
            return ChartDataEntry(x: Double(years[i]), y: data[i])
        }
        
        return entry
    }
    
    func setChartData(x1: [ChartDataEntry], x2: [ChartDataEntry], label1: String, label2: String) {
    
        let deathSet = LineChartDataSet(entries: x1, label: label1)
        deathSet.axisDependency = .left
        deathSet.setColor(UIColor(named: "AccentColor")!)
        deathSet.setCircleColor(.white)
        deathSet.lineWidth = 2
        deathSet.circleRadius = 3
        deathSet.fillAlpha = 65/255
        deathSet.fillColor = .red
        deathSet.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        deathSet.drawCircleHoleEnabled = false
        
        let hivPositiveSet = LineChartDataSet(entries: x2, label: label2)
        hivPositiveSet.axisDependency = .left
        hivPositiveSet.setColor(UIColor(named: "PrimaryColor123")!)
        hivPositiveSet.setCircleColor(.white)
        hivPositiveSet.lineWidth = 2
        hivPositiveSet.circleRadius = 3
        hivPositiveSet.fillAlpha = 65/255
        hivPositiveSet.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        hivPositiveSet.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)

        hivPositiveSet.drawCircleHoleEnabled = false
        
        let data : LineChartData = [deathSet, hivPositiveSet]
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        lineChartView.data = data
    }
    
    func msApiRequest() {
        requestTreatmentData { (msData) in
            let lastValue = (msData.last!).last!
            let lastValueString = lastValue.toString().components(separatedBy: ".")
            let treatment = lastValueString[0]
            
            self.treatmentsNumber.text = treatment
        }
    }

    
    @IBAction func openHivDetailView(_ sender: Any) {
        let loadVC = PostViewController()
        
        guard let post = postById(Int(12)) else {
            fatalError("Impossível redirecionar. Post não encontrado")
        }

        loadVC.setPost(post)

        loadVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(loadVC, animated: true)
    }
    

}

// MARK: TableView Data Source
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

        cell.accessibilityValue = "Botão \(indexPath.row+1) de \(homeTab.listItens.count)"
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = homeTabId + "\(indexPath.row)"
        
        if value == "11" {
            let loadVC = TabViewController()
            loadVC.tabId = "5"
            loadVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(loadVC, animated: true)
        } else {
            let loadVC = PostViewController()

            guard let post = postById(Int(value)!) else {
                fatalError("Impossível redirecionar. Post não encontrado")
            }

            loadVC.setPost(post)

            loadVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(loadVC, animated: true)
        }
    }
}
