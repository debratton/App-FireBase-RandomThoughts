//
//  ThoughtCell.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/11/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import Firebase

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var thoughtMsgLbl: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesCountLbl: UILabel!
    
    private var thought: Thought!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped() {
        //METHOD 1:
//        Firestore.firestore().collection(REF_THOUGHTS).document(thought.documentId).setData([REF_NUM_LIKES : thought.numLikes + 1], merge: true)
        
        //METHOD 2:
        if let updateThought = thought.documentId {
            Firestore.firestore().document("thoughts/\(updateThought)")
                .updateData([REF_NUM_LIKES : thought.numLikes + 1])
        }
        
    }
    
    func configureCell(thought: Thought) {
        self.thought = thought
        if let dateString = thought.timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let theTime = dateFormatter.string(from: dateString)
            usernameLbl.text = thought.username
            timestampLbl.text = theTime
            thoughtMsgLbl.text = thought.thoughtTxt
            likesCountLbl.text = String(thought.numLikes)
        }
        
    }

}
