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
    @IBOutlet weak var infoBtt: RedButton!
    
    var answers: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Resultado"
        
        view.backgroundColor = .backgroundColor
        
        mainStackView.backgroundColor = .secBackgroundColor
        mainStackView.clipsToBounds = true
        mainStackView.layer.cornerRadius = 10
        
        textView.backgroundColor = .secBackgroundColor
        textView.adjustsFontForContentSizeCategory = true
        
        generateText()
        
        setupAccessibility()
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func replay(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CardGame", bundle: nil)
        let loadVC = storyboard.instantiateInitialViewController()!
    
        loadVC.modalPresentationStyle = .fullScreen

        self.navigationController?.pushViewController(loadVC, animated: true)
        
        dismissAndRemoveFromNavigationStack()
    }
    
    @IBAction func moreInfo(_ sender: Any) {
        
        guard let nextPost = postById(201) else { return }
        let vc = PostViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.setPost(nextPost)
        self.navigationController?.pushViewController(vc, animated: true)

        dismissAndRemoveFromNavigationStack()
    }
}

extension GameResultViewController {
    // Ate 8 Negativo
    // 9 a 12 Neutro
    // 13 a 14 Positivo
    private func generateText(){
        let correctly = answers.filter{ $0 == true}
        
        let stringScore = "Acertou \(correctly.count) de \(answers.count)."
        
        var string = ""
        
        if correctly.count >= 13 {
            string = "\n\nBoa! Deu para ver que você anda bem informado. Não esqueça de se proteger antes de se divertir!"
        } else if correctly.count < 9 {
            string = "\n\nVocê não foi muito bem... Que tal conferir os conteúdos que preparamos para você?"
        } else {
            string = "\n\nQuase lá! Faltou pouco para gabaritar, mas conte com a gente para se manter informado."
        }
        
        textView.addBoldText(fullString: stringScore + string, boldPartOfString: [stringScore], baseFont: .preferredFont(forTextStyle: .body), boldFont: .preferredFont(forTextStyle: .title2))
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
