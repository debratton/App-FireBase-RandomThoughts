//
//  AddThoughtVC.swift
//  RandomThoughts
//
//  Created by David E Bratton on 11/11/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtVC: UIViewController {

    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var thoughtTextField: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thoughtTextField.text = "My Random thought..."
        thoughtTextField.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        thoughtTextField.delegate = self
    }
    
    @IBAction func categorySegmentChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue
        }
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        if let username = usernameTextField.text {
            if let thought = thoughtTextField.text {
                Firestore.firestore().collection(REF_THOUGHTS).addDocument(data: [
                    REF_CATEGORY: selectedCategory,
                    REF_NUM_COMMENTS: 0,
                    REF_NUM_LIKES: 0,
                    REF_THOUGHTS_MSG: thought,
                    REF_TIMESTAMP: FieldValue.serverTimestamp(),
                    REF_USERNAME: username
                ]) { (error) in
                    if let error = error {
                        debugPrint("Error Adding Thought: \(error.localizedDescription)")
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

extension AddThoughtVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        thoughtTextField.text = ""
        thoughtTextField.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
}
