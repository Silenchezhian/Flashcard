//
//  CreationViewController.swift
//  Flashcard
//
//
//  Copyright © 2020 Sahana Ilenchezhian. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var extraAnswerOneTextField: UITextField!
    @IBOutlet weak var extraAnswerTwoTextField: UITextField!
    
    var flashcardsController: ViewController!
    var questionText: String!
    var answerText: String!
    var answerOneText: String!
    var answerTwoText: String!
    
    var initialQuestion: String?
    var initialAnswer: String?
    var initialExtraAnswer1: String?
    var initialExtraAnswer2: String?
    
    var alert: UIAlertController!
    var okAction: UIAlertAction!
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
       
        //gets text in question field
        let questionText = questionTextField.text
        //gets text in answer field
        let answerText = answerTextField.text
        
        let answerOneText = extraAnswerOneTextField.text
        let answerTwoText = extraAnswerTwoTextField.text
        
    
        if (questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty || answerOneText!.isEmpty || answerTwoText!.isEmpty) {
            let alert = UIAlertController(title: "Missing text", message: "You need to enter a question and an answer", preferredStyle:UIAlertController.Style.alert)
            present(alert, animated: true)
            
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
        }
        
        else{
        //calls the function to update flashcard
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!,extraAnswer1: answerOneText!, extraAnswer2: answerTwoText!)
            
            dismiss(animated: true)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
        extraAnswerOneTextField.text = initialExtraAnswer1
        extraAnswerTwoTextField.text = initialExtraAnswer2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
