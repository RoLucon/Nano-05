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
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = self.titleLabel!.frame.size.width
        
        
    }
    
    override var intrinsicContentSize: CGSize {
        let size = self.titleLabel!.intrinsicContentSize
        return CGSize(width: size.width + contentEdgeInsets.left + contentEdgeInsets.right, height: size.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
    }
    
    fileprivate func setup() {
        traitCollectionDidChange(UITraitCollection())
        
        self.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.setContentHuggingPriority(UILayoutPriority.defaultLow + 1, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriority.defaultLow + 1, for: .horizontal)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.layoutIfNeeded()
        self.titleLabel?.font = .preferredFont(forTextStyle: .body)
        sizeToFit()
        self.setNeedsUpdateConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }){_ in
            
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) {_ in
            
        }
        super.touchesEnded(touches, with: event)
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

class TurqButton: MyButton {
    
    override func setup() {
        super.setup()
        self.backgroundColor = .secundaryColor
        self.setTitleColor(.black, for: .normal)
        
    }
    
}
