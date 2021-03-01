//
//  GameResultViewController.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 01/03/21.
//

import UIKit

class GameResultViewController: UIViewController {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backBtt: RedButton!
    @IBOutlet weak var replayBtt: RedButton!
    
    var answers: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Resultado"
        
        view.backgroundColor = .backgroundColor
        
        mainStackView.backgroundColor = .secBackgroundColor
        mainStackView.clipsToBounds = true
        mainStackView.layer.cornerRadius = 10
        
        textView.backgroundColor = .secBackgroundColor
        
        
        generateText()
        
        setupAccessibility()
        
//        removeGameFromStack()
    }
    
    @IBAction func back(_ sender: Any) {
        
    }
    
    @IBAction func replay(_ sender: Any) {
        
    }
}

extension GameResultViewController {
    
    private func removeGameFromStack(){
        var viewControllers = navigationController?.viewControllers

        guard let index = viewControllers?.firstIndex(of: self) else { return }
        
        viewControllers?.remove(at: index)

        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    private func generateText(){
        let correctly = answers.filter{ $0 == true}
        
        let string = "\n\n Acertou \(correctly.count) de \(answers.count)"
    
        if correctly.count == answers.count {
            textView.text = "Parece que esta entendendo do assunto. Parabens!" + string
        } else if correctly.count / 3 < answers.count {
            textView.text = "Você nao foi muito bem. Melhor estudar um pouco." + string
        } else {
            textView.text = "Parece que ainda esta com algumas duvidas sobre o assunto." + string
        }
    }
    
    private func setupAccessibility(){
        textView.isAccessibilityElement = true
        
        backBtt.isAccessibilityElement = true
        backBtt.accessibilityLabel = "Voltar"
        backBtt.accessibilityHint = "Clique duas veze para voltar"
        
        replayBtt.isAccessibilityElement = true
        replayBtt.accessibilityLabel = "Repetir"
        replayBtt.accessibilityHint = "Clique duas veze para repetir o jogo"
    }
}
