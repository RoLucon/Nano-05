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
    
    private let titleLabel = UILabel()
    
    private let scrollView = UIScrollView()
    
    private var stackView = UIStackView()
    
    private var textView = UITextView()
    
    private let imageView = UIImageView()
    
    private let button = RedButton()
    
    private var actions: [Action] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .accentColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryColor]
        
        view.backgroundColor = .backgroundColor
        
        let topAncor: NSLayoutYAxisAnchor
        //MARK: - Header if style == Sheet
        if modalPresentationStyle == .popover {
            
            let headerView = UIView()
            headerView.backgroundColor = .secBackgroundColor
            
            view.addSubview(headerView)
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                headerView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 0),
                headerView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 0),
                headerView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 55)
            ])
            
            titleLabel.textAlignment = .center
            titleLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .preferredFont(forTextStyle: .headline), maximumPointSize: 21)
            
            titleLabel.adjustsFontForContentSizeCategory = true
            headerView.addSubview(titleLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 50),
                titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -66),
                titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            ])
            
            let cancelBtt = UIButton()
            
            cancelBtt.setTitle("OK", for: .normal)
            cancelBtt.isAccessibilityElement = true
            cancelBtt.accessibilityLabel = "Voltar"
            cancelBtt.accessibilityHint = "Fecha a janela e volta para tela anterior"
            cancelBtt.setTitleColor(.accentColor, for: .normal)
            cancelBtt.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .preferredFont(forTextStyle: .headline), maximumPointSize: 21)
            cancelBtt.titleLabel?.adjustsFontForContentSizeCategory = true
            
            cancelBtt.addTarget(self, action: #selector(dismissC), for: .touchUpInside)
            
            headerView.addSubview(cancelBtt)
            
            cancelBtt.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                cancelBtt.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                cancelBtt.topAnchor.constraint(equalTo: headerView.topAnchor),
                cancelBtt.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
                cancelBtt.widthAnchor.constraint(equalToConstant: 44),
            ])
            
            topAncor = headerView.bottomAnchor
        } else {
            topAncor = safeGuide.topAnchor
        }
        
        //MARK: ScrollView
        scrollView.backgroundColor = .backgroundColor
        scrollView.delegate = self
        scrollView.layer.cornerRadius = 10;
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: topAncor),
            scrollView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor)
        ])
        
        var top = scrollView.topAnchor
        
        //MARK: - ImageView
        
        if let imageName = post?.imageName {
            imageView.clipsToBounds = true;
            imageView.layer.cornerRadius = 10;
            
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFit
            
            scrollView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1, constant: -32),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            ])
            top = imageView.bottomAnchor
            print("Image\(imageName)")
        }
        
        //MARK: - StackView
        stackView.axis = .vertical
        stackView.clipsToBounds = true;
        stackView.layer.cornerRadius = 10;
        stackView.spacing = 16
        stackView.backgroundColor = modalPresentationStyle == .pageSheet ? .backgroundColor : .secBackgroundColor
        
        stackView.alignment = .fill
        
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: top, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        ])
        
        //MARK: - TextView
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        textView.accessibilityTraits = .staticText
        
        stackView.addArrangedSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        update()
        
        addButtonsIfNeed(post)
        
        titleLabel.text = title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        //Remove os ultimas quebras de linha
        let substring1 = text.dropLast(2)
        text = String(substring1)
        
        textView.attributedText = addBoldText(fullString: text, boldPartOfString: title, baseFont: .preferredFont(forTextStyle: .body), boldFont: .preferredFont(forTextStyle: .headline))
    }
    
    //MARK: - ADD Buttons
    
    private func addButtonsIfNeed(_ post: Post?){
        guard let post = self.post else { return }
        
        if post.link != nil {
            
            button.setTitle(post.linkTitle, for: .normal)
            button.addTarget(self, action: #selector(moreInfos), for: .touchUpInside)
            
            button.accessibilityLabel = post.linkTitle
            button.accessibilityHint = post.linkHint
            
            stackView.addArrangedSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.removeConstraints(button.constraints)
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(greaterThanOrEqualToConstant: 55)
            ])
            button.sizeToFit()
        }
        
        guard let redirects = post.redirect else { return }
        
        for redirect in redirects {
            let button = RedButton()
            
            let actio = Action {
                if let storyboardName = redirect.storyboard {
                    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    self.navigationController?.pushViewController(vc!, animated: true)
                    return
                }
                
                if let postId = redirect.postId {
                    guard let nextPost = postById(postId) else { return }
                    let vc = PostViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.setPost(nextPost)
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
            actions.append(actio)
            button.setTitle(redirect.title, for: .normal)
            button.addTarget(self, action: #selector(dynamicActions), for: .touchUpInside)
            button.tag = actions.count - 1
            button.accessibilityLabel = redirect.title
            button.accessibilityHint = redirect.hint
            
            stackView.addArrangedSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(greaterThanOrEqualToConstant: 55)
            ])
            
        }
    }
    
    
    //MARK: - Btt Click
    @objc fileprivate func moreInfos(sender: UIButton){
        guard let link = post?.link else { return }
        
        let vc = SFSafariViewController(url: URL(string: link)!)
        
        self.present(vc, animated: true)
        
    }
    
    @objc func dynamicActions(_ sender: UIButton){
        actions[sender.tag].action()
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
    
    @objc private func dismissC(){
        self.dismiss(animated: true)
    }
}

// MARK: - TraitCollection
extension PostViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        update()
    }
    
}

final class Action: NSObject {
    private let _action: () -> ()
    
    init(action: @escaping () -> ()) {
        _action = action
        super.init()
    }
    
    @objc func action() {
        _action()
    }
}
