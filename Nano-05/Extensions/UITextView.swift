//
//  UITextView.swift
//  Nano-05
//
//  Created by Rogerio Lucon on 26/02/21.
//

import UIKit

extension UITextView {
    
    func addBoldText(fullString: String, boldPartOfString: [String], baseFont: UIFont, boldFont: UIFont){
        
        let baseFontAttribute = [NSAttributedString.Key.font : baseFont]
        let boldFontAttribute = [NSAttributedString.Key.font : boldFont]
        
        let attributedString = NSMutableAttributedString(string: fullString, attributes: baseFontAttribute)
        
        for string in boldPartOfString {
            attributedString.addAttributes(boldFontAttribute, range: NSRange(fullString.range(of: string) ?? fullString.startIndex..<fullString.endIndex, in: fullString))
        }
        self.attributedText = attributedString
    }
}
