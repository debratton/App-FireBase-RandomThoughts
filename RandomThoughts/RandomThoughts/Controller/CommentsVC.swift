//
//  CommentsVC.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/12/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var keyboardView: UIView!
    
    // Holds passed thought class from MainVC
    var comment: Thought!
    var comments = [Comment]()
    var thoughtRef: DocumentReference!
    let firestore = Firestore.firestore()
    var username: String!
    var commentListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        tableView.delegate = self
        tableView.dataSource = self
        thoughtRef = firestore.collection(REF_THOUGHTS).document(comment.documentId)
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commentListener = firestore.collection(REF_THOUGHTS).document(self.comment.documentId)
            .collection(REF_COMMENTS).addSnapshotListener({ (snapshot, error) in
                guard let snapshot = snapshot else {
                    debugPrint("Error Fetching Comments: \(error!.localizedDescription)")
                    return
                }
                self.comments.removeAll()
                self.comments = Comment.parseData(snapshot: snapshot)
                self.tableView.reloadData()
            })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        commentListener.remove()
    }
    
    @IBAction func commentBtnPressed(_ sender: Any) {
        guard let commentTxt = commentText.text else { return }
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let thoughtDocument: DocumentSnapshot
            do {
                try thoughtDocument = transaction.getDocument(self.firestore.collection(REF_THOUGHTS).document(self.comment.documentId))
            } catch let error as NSError {
                debugPrint("Error Fetching: \(error.localizedDescription)")
                return nil
            }
            guard let oldNumComments = thoughtDocument.data()![REF_NUM_COMMENTS] as? Int else { return nil }
            transaction.updateData([REF_NUM_COMMENTS : oldNumComments + 1], forDocument: self.thoughtRef)
            
            let newCommentRef = self.firestore.collection(REF_THOUGHTS).document(self.comment.documentId).collection(REF_COMMENTS).document()
            transaction.setData([
                REF_COMMENT_TXT : commentTxt,
                REF_TIMESTAMP : FieldValue.serverTimestamp(),
                REF_USERNAME : self.username
                ], forDocument: newCommentRef)
            
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction Failed: \(error.localizedDescription)")
            } else {
                self.commentText.text = ""
            }
        }
    }
}

extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
            cell.configureCell(comment: comments[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
