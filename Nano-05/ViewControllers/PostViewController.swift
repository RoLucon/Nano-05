//
//  PostViewController.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 23/02/21.
//

import UIKit
import SafariServices

class PostViewController: UIViewController, UIScrollViewDelegate {
    
    private var post: Post?
    
    private let scrollView = UIScrollView()
    
    private var stackView = UIStackView()
    
    private var textView = UITextView()
    
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .accentColor
        
        view.backgroundColor = .backgroundColor
        
        //MARK: ScrollView
        scrollView.backgroundColor = .backgroundColor
        scrollView.delegate = self
        scrollView.layer.cornerRadius = 10;
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor)
        ])
        
        //MARK: - StackView
        stackView.axis = .vertical
        stackView.clipsToBounds = true;
        stackView.layer.cornerRadius = 10;
        
        stackView.backgroundColor = .secBackgroundColor
        
        stackView.alignment = .fill
        
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 40, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                        stackView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 16),
                        stackView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40)
        ])
        
        //MARK: - TextView
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        stackView.addArrangedSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        update()
    }
    
    //MARK: - UPDATE
    private func update() {
        guard let post = self.post else { return }
        
        update(post)
    }
    
    private func update(_ post: Post) {
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
        
        guard let link = post.link else { return }
        
        button.backgroundColor = .accentColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        
        button.titleLabel?.textColor = .white
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        
        button.setTitle("Mais informações", for: .normal)
        button.addTarget(self, action: #selector(moreInfos), for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let aux = button.intrinsicContentSize.height > 68 ? 40 : 16
        let size: CGFloat = max(55, button.intrinsicContentSize.height +  CGFloat(aux))
        
        button.removeConstraints(button.constraints)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: size)
        ])
        
        
    }
    //MARK: - Btt Click
    @objc fileprivate func moreInfos(sender: UIButton){
        guard let link = post?.link else { return }
        
        animatedView(sender) {
            let vc = SFSafariViewController(url: URL(string: link)!)
            
            self.present(vc, animated: true)
        }
    }
    
    //Animaçao do Click
    fileprivate func animatedView(_ viewToAnimate: UIView, complition: (() -> Void)?) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) {_ in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) {_ in
                if let closer = complition {
                    closer()
                }
            }
        }
    }
    
    //MARK: - Other Functions
    func setPost(_ post: Post) {
        self.post = post
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
        update()
    }
    
}
