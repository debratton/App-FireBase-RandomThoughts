//
//  Comment.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/13/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    private(set) var username: String!
    private(set) var timestamp: Date!
    private(set) var commentTxt: String!
    
    init(username: String, timestamp: Date, commentTxt: String) {
        self.username = username
        self.timestamp = timestamp
        self.commentTxt = commentTxt
    }
    // MOVED CODE FROM MainVC IN setListen()
    class func parseData(snapshot: QuerySnapshot?) -> [Comment] {
        var comments = [Comment]()
        guard let snaps = snapshot else { return comments }
        for snap in (snaps.documents) {
            print("Item: \(snap.data())")
            let data = snap.data()
            let username = data[REF_USERNAME] as? String ?? "Anonymous"
            let timestamp = data[REF_TIMESTAMP] as? Date ?? Date()
            let commentTxt = data[REF_COMMENT_TXT] as? String ?? ""

            let newComment = Comment(username: username, timestamp: timestamp, commentTxt: commentTxt)
            comments.append(newComment)
        }
        return comments
    }

}
