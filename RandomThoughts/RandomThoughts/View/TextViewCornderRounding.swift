//
//  TextViewCornderRounding.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/11/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit

class TextViewCornderRounding: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorners()
    }
    
    func roundCorners() {
        layer.cornerRadius = 4
    }

}
