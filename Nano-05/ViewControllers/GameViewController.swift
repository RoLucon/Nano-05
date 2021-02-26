//
//  GameViewController.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 25/02/21.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var buttonStackVew: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var showAnswersBtt: UIButton!
    @IBOutlet weak var nextQuestionBtt: UIButton!
    
    private var answerOpen = false
    
    private let cards: [Card] = card
    
    private var currentCard: UIView!
    
    private var currentAswer = 0
    
    private let gesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        mainStackView.backgroundColor = .secBackgroundColor
        mainStackView.clipsToBounds = true
        mainStackView.layer.cornerRadius = 10
        
        mainView.backgroundColor = .secBackgroundColor
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 10
        
        textView.backgroundColor = .secBackgroundColor
        
        gesture.addTarget(self, action: #selector(swipeCard))
        
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        
        leftButton.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        
        showAnswersBtt.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        
        nextQuestionBtt.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        
        nextQuestionBtt.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
       addCard()
    }
    
    private func addCard() {
        let viewCard = UIView()
        viewCard.frame = CGRect(x: 0, y: 0, width: mainView.frame.width - 32, height: mainView.frame.height - 32)
        viewCard.center = mainView.center
        viewCard.backgroundColor = .blue
        viewCard.clipsToBounds = true
        viewCard.layer.cornerRadius = 10
        
        view.addSubview(viewCard)
        
        currentCard = viewCard
        textView.text = cards[currentAswer].text
    }
    
    private func showAnswer() {
        if !answerOpen {
            answerOpen = !answerOpen
            buttonStackVew.isHidden = true
            showAnswersBtt.isHidden = true
            nextQuestionBtt.isHidden = false
            //Seta o texto
            textView.text.append(cards[currentAswer].answer)
            UIView.transition(with: mainStackView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            UIView.transition(with: mainView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            UIView.transition(with: currentCard, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            
        } else {
            answerOpen = !answerOpen
            buttonStackVew.isHidden = false
            showAnswersBtt.isHidden = false
            nextQuestionBtt.isHidden = true
            changeCard()
            //Passa o card
            UIView.transition(with: mainStackView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            UIView.transition(with: mainView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            UIView.transition(with: currentCard, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    private func changeCard() {
        textView.text = card[currentAswer].text
    }
    
    //MARK: - Actions
    
    @objc func nextQuestion() {
        if currentAswer + 1 < cards.count {
            currentAswer += 1
        } else {
            //Finaliza
        }
        
        showAnswer()
    }
    
    @objc func rightButtonClick(_ sender: UIButton) {
        showAnswer()
    }
    
    @objc func leftButtonClick(_ sender: UIButton) {
        showAnswer()
    }
    //Desativado
    @objc func swipeCard(_ sender: UIPanGestureRecognizer) {
        guard let card = sender.view else { return }
        
        let point = sender.translation(in: mainView)
        
        let initClick = sender.location(in: card)
        let topClick = initClick.y < card.frame.height / 2
        
        let xFromCenter = card.center.x - view.center.x
        
        if xFromCenter < 1 {
//            image.backgroundColor = .red
        } else if xFromCenter > 1 {
//            image.backgroundColor = .green
        } else {
//            image.backgroundColor = .clear
        }
        
        //Muda alpha conforme aproxima da borda
//        image.alpha = abs (xFromCenter / view.center.x)
        
        card.center = CGPoint(x: mainView.center.x + point.x, y: mainView.center.y + point.y)
        
        //Rotaçao
        let maxAngle: CGFloat = CGFloat(35 * Double.pi / 180)
        var angle: CGFloat = xFromCenter / ((view.frame.width / 2) / maxAngle)
        angle = angle * (topClick ? -1 : 1)
        //Scala
        let scale = min(abs(100 / xFromCenter * 1.5), 1)
        
        card.transform = CGAffineTransform(rotationAngle: angle).scaledBy(x: scale, y: scale)
        
        if sender.state == .ended {
            
            if card.center.x < -50 {
                //movido para esquerda
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y)
                    card.alpha = 0
                }
                return
            } else if card.center.x > view.frame.width - 50 {
                //movido para direita
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y)
                    card.alpha = 0
                }
                return
            }
            
            UIView.animate(withDuration: 0.2) {
                card.center = self.mainView.center
                card.transform = .identity
            }
        }
    }
}
