//
//  ViewController.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/11/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    
    private var thoughts = [Thought]()
    private var thoughtsCollRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        thoughtsCollRef = Firestore.firestore().collection(REF_THOUGHTS)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        thoughtsListener.remove()
    }
    
    func setListener() {
        if selectedCategory == ThoughtCategory.popular.rawValue {
            thoughtsListener = thoughtsCollRef
                //.whereField(REF_CATEGORY, isEqualTo: selectedCategory)
                //.order(by: REF_TIMESTAMP, descending: true)
                .order(by: REF_NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        debugPrint("Error Fetching Firebase Objects \(error.localizedDescription)")
                    } else {
                        // Have to remove previous or they keep duplicating
                        self.thoughts.removeAll()
//                        guard let snaps = snapshot else { return }
//                        for snap in (snaps.documents) {
//                            print("Item: \(snap.data())")
//                            let data = snap.data()
//                            let username = data[REF_USERNAME] as? String ?? "Anonymous"
//                            let timestamp = data[REF_TIMESTAMP] as? Date ?? Date()
//                            let thoughtTxt = data[REF_THOUGHTS_MSG] as? String ?? ""
//                            let numLikes = data[REF_NUM_LIKES] as? Int ?? 0
//                            let numComments = data[REF_NUM_COMMENTS] as? Int ?? 0
//                            let documentId = snap.documentID
//                            
//                            let newThought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId)
//                            self.thoughts.append(newThought)
//                        }
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        self.tableView.reloadData()
                    }
            }
        } else {
            thoughtsListener = thoughtsCollRef
                .whereField(REF_CATEGORY, isEqualTo: selectedCategory)
                .order(by: REF_TIMESTAMP, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        debugPrint("Error Fetching Firebase Objects \(error.localizedDescription)")
                    } else {
                        // Have to remove previous or they keep duplicating
                        self.thoughts.removeAll()
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        self.tableView.reloadData()
                    }
            }
        }
    }
    
    @IBAction func categorySegmentPressed(_ sender: Any) {
        switch categorySegmentControl.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.popular.rawValue
        }
        thoughtsListener.remove()
        setListener()
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
