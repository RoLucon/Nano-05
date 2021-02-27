//
//  CardView.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 25/02/21.
//

import UIKit

class CardView: UIView {

    let nibName = "CardView"
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        func commonInit() {
            guard let view = loadViewFromNib() else { return }
            view.frame = self.bounds
            self.addSubview(view)
        }
        
        func loadViewFromNib() -> UIView? {
            let nib = UINib(nibName: nibName, bundle: nil)
            return nib.instantiate(withOwner: self, options: nil).first as? UIView
        }

}
