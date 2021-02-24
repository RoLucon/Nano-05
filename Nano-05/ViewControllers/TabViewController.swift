//
//  PostViewController.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 19/02/21.
//

import UIKit

class TabViewController: UIViewController, UITableViewDelegate {
    
    @IBInspectable var tabId: String!
    
    private var currentTab: Tab!
    
    private let scrollView = UIScrollView()
    
    private let tableView = UITableView()
    
    private let textView = UITextView()
    
    private var tableViewHeight: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        traitCollectionDidChange(UITraitCollection())
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let stringId = tabId else { return }
        
        guard let id = Int(stringId) else { return }
        
        let auxTab : [Tab] = tab.filter { $0.id == id}
        
        guard let currentTab = auxTab.first else { return }
        
        self.currentTab = currentTab
        
        title = currentTab.title
        
        //MARK: ScrollView
        scrollView.backgroundColor = .gray
        scrollView.delegate = self
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
            textView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1, constant: -32)
        ])
        
        textView.text = currentTab.text
        
        //MARK: - List TableView

        tableView.layer.cornerRadius = 10;

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")

        scrollView.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 32),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
        ])
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
}

// MARK: - TableViewDataSource

extension TabViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTab.listItens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = currentTab.listItens[indexPath.row].title
        cell.accessoryType =  UITableViewCell.AccessoryType.disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tab: \(tabId), Row: \(indexPath.row)")
        
        let loadVC = PostViewController()
        loadVC.modalPresentationStyle = .fullScreen
        
        guard let post = postById(11) else {
            fatalError("Impossivel redirecionar. Post não encontrado.")
        }
        
        loadVC.setPost(post)
        
        self.navigationController?.pushViewController(loadVC, animated: true)
        
    }
}

// MARK: - TraitCollection
extension TabViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        textView.font = .preferredFont(forTextStyle: .body)
    }
    
}


