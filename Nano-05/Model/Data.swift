//
//  Data.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 19/02/21.
//

import Foundation

let post: [Post] = load("Posts.json")
let tab: [Tab] = load("Tabs.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    print(file)
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func postById(_ id: Int) -> Post? {
    let filter = post.filter { $0.id == id }
    
    return filter.first
}

// método que faz a requisição da api da OMS
func requestData(url: String, completion: @escaping ([WhoData]) -> ()) {
    var whoData: [WhoData] = []
    
    guard let url = URL(string: url) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, _, _) in
        let jsonWhoData = try! JSONDecoder().decode(Values.self, from: data!)
        
        whoData = jsonWhoData.value
        
        DispatchQueue.main.async {
            completion(whoData)
        }

    }.resume()
}

// método que separa os números dos dados da api
func getDeathsValue(whoData: [WhoData]) -> [Double] {
    var deaths = [Double]()
    
    // de 3 em 3 anos
    for i in stride(from: 1, to: whoData.count, by: 3) {
        let index = i
        
        deaths.append(whoData[index].NumericValue)
    }
    
    return deaths
}


func getInfectedValue(whoData: [WhoData]) -> [Double] {
    var infected = [Double]()
    
    // de 3 em 3 anos
    for i in stride(from: 1, to: whoData.count, by: 3) {
        let index = i
        
        infected.append(whoData[index].NumericValue)
    }
    
    return infected
}

func getYearsValue(whoData: [WhoData]) -> [Int] {
    var years = [Int]()
    
    // de 3 em 3 anos
    for i in stride(from: 1, to: whoData.count, by: 3) {
        let index = i
        
        years.append(whoData[index].TimeDim)
    }
    
    return years
}
