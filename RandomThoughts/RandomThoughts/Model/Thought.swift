//
//  Thought.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/11/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import Foundation
import Firebase

class Thought {
    private(set) var username: String!
    private(set) var timestamp: Date!
    private(set) var thoughtTxt: String!
    private(set) var numLikes: Int!
    private(set) var numComments: Int!
    private(set) var documentId: String!
    
    init(username: String, timestamp: Date, thoughtTxt: String, numLikes: Int, numComments: Int, documentId: String) {
        self.username = username
        self.timestamp = timestamp
        self.thoughtTxt = thoughtTxt
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
    }
    // MOVED CODE FROM MainVC IN setListen()
    class func parseData(snapshot: QuerySnapshot?) -> [Thought] {
        var thoughts = [Thought]()
        guard let snaps = snapshot else { return thoughts }
        for snap in (snaps.documents) {
            print("Item: \(snap.data())")
            let data = snap.data()
            let username = data[REF_USERNAME] as? String ?? "Anonymous"
            let timestamp = data[REF_TIMESTAMP] as? Date ?? Date()
            let thoughtTxt = data[REF_THOUGHTS_MSG] as? String ?? ""
            let numLikes = data[REF_NUM_LIKES] as? Int ?? 0
            let numComments = data[REF_NUM_COMMENTS] as? Int ?? 0
            let documentId = snap.documentID
            
            let newThought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId)
            thoughts.append(newThought)
        }
        return thoughts
    }
}
