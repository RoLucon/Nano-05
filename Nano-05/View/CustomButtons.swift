//
//  CustomButtons.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 26/02/21.
//

import UIKit

class MyButton: UIButton {
    
    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    fileprivate func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
}

class RedButton: MyButton {
    
    override func setup() {
        super.setup()
        self.backgroundColor = .accentColor
        self.setTitleColor(.white, for: .normal)
    }
    
}

class PurpleButton: MyButton {
    
    override func setup() {
        super.setup()
        self.backgroundColor = .primaryColor
        self.setTitleColor(.white, for: .normal)
    }
    
}
