//
//  GameViewController.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 25/02/21.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    private var currentQuestion = 0
    
    private var isAnswer: [Bool] = []
    
    private let gesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        mainStackView.backgroundColor = .secBackgroundColor
        mainStackView.clipsToBounds = true
        mainStackView.layer.cornerRadius = 10
        
        mainView.backgroundColor = .green//.secBackgroundColor
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 10
        
        textView.backgroundColor = .secBackgroundColor
        
        textView.adjustsFontForContentSizeCategory = true
        textView.font = .preferredFont(forTextStyle: .body)
        
        gesture.addTarget(self, action: #selector(swipeCard))
        
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
 
        leftButton.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        
        showAnswersBtt.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        
        nextQuestionBtt.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        
        nextQuestionBtt.isHidden = true
        
        setupAccessibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       addCard()
    }
    
    private func addCard() {
//        let viewCard = UIView()
//        viewCard.frame = CGRect(x: 0, y: 0, width: mainView.frame.width - 32, height: mainView.frame.height - 32)
//        viewCard.center = (mainView.superview?.convert(mainView.center, to: nil))!
//        viewCard.backgroundColor = .blue
//        viewCard.clipsToBounds = true
//        viewCard.layer.cornerRadius = 10
//        viewCard.addGestureRecognizer(gesture)
//        view.addSubview(viewCard)
//
//        print(viewCard.center)
//        print(mainView.center)
//
//        currentCard = viewCard
        textView.addBoldText(fullString: cards[currentQuestion].text, boldPartOfString: [cards[currentQuestion].text], baseFont: .preferredFont(forTextStyle: .body), boldFont: .preferredFont(forTextStyle: .headline))
        
        updateAccessibility()
    }
    
    private func showAnswer() {
        
        if !answerOpen {
            answerOpen = !answerOpen
            buttonStackVew.isHidden = true
            showAnswersBtt.isHidden = true
            nextQuestionBtt.isHidden = false
            //Seta o texto
            let fullString = cards[currentQuestion].text + "\n\n" + cards[currentQuestion].answer
            textView.addBoldText(fullString: fullString, boldPartOfString: [cards[currentQuestion].text], baseFont: .preferredFont(forTextStyle: .body), boldFont: .preferredFont(forTextStyle: .headline))
            UIView.transition(with: mainStackView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            UIView.transition(with: mainView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
//            UIView.transition(with: currentCard, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            
        } else {
            answerOpen = !answerOpen
            buttonStackVew.isHidden = false
            showAnswersBtt.isHidden = false
            nextQuestionBtt.isHidden = true
            changeCard()
            //Passa o card
            UIView.transition(with: mainStackView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            UIView.transition(with: mainView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
//            UIView.transition(with: currentCard, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        updateAccessibility()
        UIAccessibility.post(notification: .screenChanged, argument: "mainView")
    }
    
    private func changeCard() {
        textView.addBoldText(fullString: cards[currentQuestion].text, boldPartOfString: [cards[currentQuestion].text], baseFont: .preferredFont(forTextStyle: .body), boldFont: .preferredFont(forTextStyle: .headline))
        updateAccessibility()
    }
    
    private func concludeGame() {
        let storyboard = UIStoryboard(name: "CardGame", bundle: nil)
        let loadVC = storyboard.instantiateViewController(identifier: "GameResult") as! GameResultViewController
        loadVC.answers = isAnswer
        loadVC.modalPresentationStyle = .fullScreen

        self.navigationController?.pushViewController(loadVC, animated: true)
        
        var viewControllers = navigationController?.viewControllers

        guard let index = viewControllers?.firstIndex(of: self) else { return }
        
        viewControllers?.remove(at: index)

        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    private func feedback(_ flag: Bool) {
        if card[currentQuestion].answerValue == flag {
            isAnswer.append(true)
            feedbackGenerator(.success)
        } else {
            isAnswer.append(false)
            feedbackGenerator(.error)
        }
    }
    
    //MARK: - Actions
    
    @objc func nextQuestion() {
        if currentQuestion + 1 < cards.count {
            currentQuestion += 1
        } else {
            concludeGame()
        }
        showAnswer()
    }
    
    @objc func rightButtonClick(_ sender: UIButton?) {
        feedback(true)
        showAnswer()
    }
    
    @objc func leftButtonClick(_ sender: UIButton?) {
        feedback(false)
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
                card.center = (self.mainView.superview?.convert(self.mainView.center, to: nil))!
                card.transform = .identity
            }
        }
    }
}
    //MARK: - ACCESSIBILITY
extension GameViewController {
    
    override func accessibilityActivate() -> Bool {

        return true
    }
    
    private func setupAccessibility() {

        textView.isAccessibilityElement = true
        
        textView.accessibilityIdentifier = "textView"

        textView.accessibilityLabel = textView.text
        textView.accessibilityHint = "Interaja com a imagem para responder se Pega ou não Pega HIV de acordo com a afirmaçao"
        textView.accessibilityValue = "Pergunta \(currentQuestion) de \(cards.count)"
    }
    
    private func updateAccessibility() {
        
        let pega = UIAccessibilityCustomAction(name: "Pega", target: self, selector: #selector(leftButtonClick(_:)))
        let naoPega = UIAccessibilityCustomAction(name: "Não Pega", target: self, selector: #selector(rightButtonClick(_:)))
        let showAnserCustomAction = UIAccessibilityCustomAction(name: "Ver Resposta", target: self, selector: #selector(nextQuestion))
        let nextAnserCustomAction = UIAccessibilityCustomAction(name: "Proxima pergunta", target: self, selector: #selector(nextQuestion))
        
        if answerOpen {
            textView.accessibilityCustomActions = [nextAnserCustomAction]
        } else {
            
            textView.accessibilityCustomActions = [pega, naoPega, showAnserCustomAction]
        }

        textView.accessibilityLabel = textView.text
        textView.accessibilityHint = answerOpen ? "Resposta" : "Interaja com a imagem para responder se Pega ou não Pega HIV de acordo com a afirmaçao"
        textView.accessibilityValue = "Pergunta \(currentQuestion) de \(cards.count)"
    }
}


