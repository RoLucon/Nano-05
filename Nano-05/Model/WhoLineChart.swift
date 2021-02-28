//
//  WhoLineChart.swift
//  Nano-05
//
//  Created by Beatriz Sato on 28/02/21.
//

import Foundation
import Charts

class WhoLineChart {
    var data = LineChartData()
    
    // dados prontos para entrarem no gráfico a partir dos vetores
    var dataDeath = [ChartDataEntry]()
    var dataInfected = [ChartDataEntry]()
    
    // conjunto de linhas customizáveis
    var deathDataSet = LineChartDataSet()
    var infectedDataSet = LineChartDataSet()

    init() {
        
    }
    
    init(years: [Int], deaths: [Double], infected: [Double], deathColor: NSUIColor, infectedColor: NSUIColor) {
        setDataEntry(yDeaths: deaths, yInfected: infected, xYears: years)
        
        setDeathDataSet(color: deathColor)
        setInfectedDataSet(color: infectedColor)
        
        setChartData()
    }
    
    // pega os conjuntos de dados das linhas e coloca no gráfico
    func setChartData() {
        var dataSets = [ChartDataSetProtocol]()
        
        dataSets.append(deathDataSet)
        dataSets.append(infectedDataSet)
        
        // junta os dados
        data = LineChartData(dataSets: dataSets)
    }
    
    // customização da linha de morte do gráfico
    func setDeathDataSet(color: NSUIColor) {
        deathDataSet = LineChartDataSet(entries: dataDeath, label: "Mortes")
        
        
        deathDataSet.setColor(color)
        deathDataSet.drawCirclesEnabled = false
        
        // seta o tamanho da fonte dos valores da linha
        deathDataSet.valueFont = .systemFont(ofSize: 10)
        
        deathDataSet.lineWidth = 3
    }
    
    // customização da linha de morte do gráfico
    func setInfectedDataSet(color: NSUIColor) {
        infectedDataSet = LineChartDataSet(entries: dataInfected, label: "Infectados")
        
        infectedDataSet.drawCirclesEnabled = false
        infectedDataSet.setColor(color)
        
        infectedDataSet.lineWidth = 3
    }
    
    
    
    // pega os vetores e transforma em algo usável pelo gráfico
    func setDataEntry(yDeaths: [Double], yInfected: [Double], xYears: [Int]) {
        for i in 0..<yDeaths.count {
            let deathEntry = ChartDataEntry(x: Double(xYears[i]), y: yDeaths[i])
            let livingEntry = ChartDataEntry(x: Double(xYears[i]), y: yInfected[i])
            
            dataDeath.append(deathEntry)
            dataInfected.append(livingEntry)
        }
    }
}
