//
//  PostViewController.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 19/02/21.
//

import UIKit
import SafariServices

class TabViewController: UIViewController, UITableViewDelegate {
    
    @IBInspectable var tabId: String!
    
    private var currentTab: Tab!
    
    private let scrollView = UIScrollView()
    
    private let tableView = UITableView()
    
    private let textView = UITextView()
    
    private let listTitleLabel = UILabel()
    
    private var tableViewHeight: NSLayoutConstraint?
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        traitCollectionDidChange(UITraitCollection())
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .accentColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryColor]
        
        view.backgroundColor = .backgroundColor
        
        guard let stringId = tabId else { return }
        
        guard let id = Int(stringId) else { return }
        
        let auxTab : [Tab] = tab.filter { $0.id == id}
        
        guard let currentTab = auxTab.first else { return }
        
        self.currentTab = currentTab
        
        title = currentTab.title
        
        //MARK: ScrollView
        scrollView.backgroundColor = .backgroundColor
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor)
        ])
        
        var top = scrollView.topAnchor
        
        //MARK: - Image
        if let imageName = currentTab.imageName {
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
        
        //MARK: - Text View
        textView.backgroundColor = .secBackgroundColor
        textView.clipsToBounds = true;
        textView.layer.cornerRadius = 10;
        textView.isScrollEnabled = false
        textView.isEditable = false
        
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        scrollView.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: top, constant: 16),
            textView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1, constant: -32)
        ])
        
        textView.text = currentTab.text
        
        //MARK: - List / TableView
        
        //        tableView.layer.cornerRadius = 10;
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
        
        scrollView.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
        ])
        
        
        // MARK: Fontes e Créditos "Links Externos"
        if currentTab.listTitle != nil {
            listTitleLabel.text = currentTab.listTitle
            listTitleLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .preferredFont(forTextStyle: .headline), maximumPointSize: 21)
            
            scrollView.addSubview(listTitleLabel)
            
            listTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                listTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                listTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
                listTitleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
                
            ])
        }
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
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

// MARK: - TableViewDataSource

extension TabViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTab.listItens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = currentTab.listItens[indexPath.row].title
        cell.isAccessibilityElement = true
        
        if let hint = currentTab.listItens[indexPath.row].titleHint {
            cell.accessibilityHint = hint
        } else {
            cell.accessibilityHint = "Clique para ver mais sobre \(currentTab.listItens[indexPath.row].title) "
        }
        cell.accessibilityValue = "Botão \(indexPath.row) de \(currentTab.listItens.count)"
        cell.accessoryType =  UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = tabId + "\(indexPath.row)"
        let loadVC = PostViewController()
        
        if tabId != "5" {
            guard let post = postById(Int(value)!) else {
                fatalError("Impossivel redirecionar. Post não encontrado.")
            }
            
            loadVC.setPost(post)
            
            if post.modal == "sheet" {
                loadVC.modalPresentationStyle = .popover
                present(loadVC, animated: true)
            } else {
                loadVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(loadVC, animated: true)
            }
            
            // se for a parte de fontes e créditos
        } else {
            guard let tabPost = tabById(5) else {
                fatalError("Impossível redirecionar. Post não encontrado")
            }
            
            guard let link = tabPost.listItens[indexPath.row].link else { return }
            
            let vc = SFSafariViewController(url: URL(string: link)!)
            
            self.present(vc, animated: true)
        }
    }
}

// MARK: - TraitCollection
extension TabViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        textView.font = .preferredFont(forTextStyle: .body)
    }
    
}


