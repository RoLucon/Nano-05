//
//  PostViewController.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 23/02/21.
//

import UIKit

class PostViewController: UIViewController, UIScrollViewDelegate {
    
    private var post: Post?
    
    private let scrollView = UIScrollView()
    
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        //MARK: ScrollView
        scrollView.backgroundColor = .gray
        scrollView.delegate = self
        scrollView.layer.cornerRadius = 10;
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -8),
            scrollView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor)
        ])
        
        //MARK: - Text View
        textView.backgroundColor = .white
        textView.clipsToBounds = true;
        textView.layer.cornerRadius = 10;
        textView.isScrollEnabled = false
        textView.isEditable = false
        
        scrollView.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            textView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1, constant: -32)
        ])
            
//        let aux = "PLEASE NOTE:\n\n\n A única forma de prevenção eficaz contra qualquer IST e o próprio HIV é o uso de camisinha durante as relações sexuais. Tanto as camisinhas masculinas quanto as femininas são distribuídas nos postos de saúde.\n\nNo caso específico do HIV, há agora um novo método preventivo: a Profilaxia Pré Exposição, indicada para os grupos que tem maior risco de contrair o vírus.\n\nEm caso de risco de infecção, há outras medidas que podem ser tomadas para minimizar o risco, como a profilaxia pós exposição."
        
        
//        textView.attributedText = addBoldText(fullString: aux, boldPartOfString: ["PLEASE NOTE", "contra"], baseFont: .preferredFont(forTextStyle: .body), boldFont: .preferredFont(forTextStyle: .title1))
        

    }

    func update(_ post: Post) {
        title = post.title
        
         var text = ""
        
        var title: [String] = []
        
        for info in post.info {
            
            if info.title.count > 0 {
                text += info.title
                title.append(info.title)
                text += "\n\n"
            }
            
            text += info.text
            text += "\n\n"
        }
        
        textView.attributedText = addBoldText(fullString: text, boldPartOfString: title, baseFont: .preferredFont(forTextStyle: .body), boldFont: .preferredFont(forTextStyle: .headline))
    }
    
    func addBoldText(fullString: String, boldPartOfString: [String], baseFont: UIFont, boldFont: UIFont) -> NSAttributedString {

        let baseFontAttribute = [NSAttributedString.Key.font : baseFont]
        let boldFontAttribute = [NSAttributedString.Key.font : boldFont]

        let attributedString = NSMutableAttributedString(string: fullString, attributes: baseFontAttribute)
        
        for string in boldPartOfString {
            attributedString.addAttributes(boldFontAttribute, range: NSRange(fullString.range(of: string) ?? fullString.startIndex..<fullString.endIndex, in: fullString))
        }
        
        

        return attributedString
    }
}

// MARK: - TraitCollection
extension PostViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        textView.font = .preferredFont(forTextStyle: .body)
    }
    
}
