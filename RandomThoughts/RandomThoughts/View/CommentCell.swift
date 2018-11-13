//
//  CommentCell.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/13/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import Firebase

class CommentCell: UITableViewCell {

    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var timestampText: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    private var comment: Comment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(comment: Comment) {
        self.comment = comment
        if let dateString = comment.timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let theTime = dateFormatter.string(from: dateString)
            usernameText.text = comment.username
            timestampText.text = theTime
            commentText.text = comment.commentTxt
        }
    }
}
