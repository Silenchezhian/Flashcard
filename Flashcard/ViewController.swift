//
//  ViewController.swift
//  Flashcard
//
//
//  Copyright © 2020 Sahana Ilenchezhian. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var extraAnswer1: String
    var extraAnswer2: String
}

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var flashcards = [Flashcard]()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rounded corners
        card.layer.cornerRadius = 20.0
        
        backLabel.layer.cornerRadius = 20.0
        backLabel.clipsToBounds = true
        
        frontLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        
        
        //shadows
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        //layout for buttons
        btn1.layer.borderWidth = 3.0
        btn1.layer.borderColor = #colorLiteral(red: 0.5323996126, green: 1, blue: 0.6806098388, alpha: 1)
        btn1.layer.cornerRadius = 20.0
        btn1.clipsToBounds = true
        
        btn2.layer.borderWidth = 3.0
        btn2.layer.borderColor = #colorLiteral(red: 0.5323996126, green: 1, blue: 0.6806098388, alpha: 1)
        btn2.layer.cornerRadius = 20.0
        btn2.clipsToBounds = true
        
        btn3.layer.borderWidth = 3.0
        btn3.layer.borderColor = #colorLiteral(red: 0.5323996126, green: 1, blue: 0.6806098388, alpha: 1)
        btn3.layer.cornerRadius = 20.0
        btn3.clipsToBounds = true
        
        //reads saved Flashcards
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the capital of Australia?", answer: "Canberra", extraAnswer1: "Melbourne", extraAnswer2: "Sydney", isExisting: true)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }


    @IBAction func didTapOnFlashcard(_ sender: Any) {
        
        
        if(frontLabel.isHidden){
            frontLabel.isHidden = false
        }
        else{
            frontLabel.isHidden = true
        }
        
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete flashcard", message:"Are you sure you want to delete it?", preferredStyle: .actionSheet)
        present(alert, animated: true)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {action in self.deleteCurrentFlashcard()}
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
    }
    
    func deleteCurrentFlashcard(){
        
        //delete current, if not the only flashcard in set
        if flashcards.count != 1 {
            flashcards.remove(at: currentIndex)
        }
        
        else if flashcards.count == 1{
            let alert = UIAlertController(title: "Flashcard cannot be deleted", message: "You cannot delete the last flashcard in the deck", preferredStyle:UIAlertController.Style.alert)
            present(alert, animated: true)
            
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
        }
        //checks if last card was deleted
        if currentIndex > flashcards.count - 1{
            currentIndex = flashcards.count - 1
        }
        
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    @IBAction func didTapOnNext(_ sender: Any) {
        //update currentIndex
        currentIndex = currentIndex + 1
        
        //update labels
        updateLabels()
        
        //update buttons
        updateNextPrevButtons()
    }
    
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //update currentIndex
        currentIndex = currentIndex - 1
        
        //update labels
        updateLabels()
        
        //update buttons
        updateNextPrevButtons()
    }
    
    func updateLabels(){
        //get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        //update buttons
        btn2.setTitle(currentFlashcard.answer, for: UIControl.State.normal)
        btn1.setTitle(currentFlashcard.extraAnswer1, for: UIControl.State.normal)
        btn3.setTitle(currentFlashcard.extraAnswer2, for: UIControl.State.normal)
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswer1: String, extraAnswer2: String, isExisting: Bool){
        let flashcard = Flashcard(question: question, answer: answer, extraAnswer1: extraAnswer1, extraAnswer2: extraAnswer2)
        if isExisting{
            //replace existing flashcard
            flashcards[currentIndex] = flashcard
        } else {
            //Adding flashcards in the flashcard array
            flashcards.append(flashcard)
            
            //Logging to the console
            print("added new flashcard!")
            print("we now have \(flashcards.count) flashcards")
            
            //update current index
            currentIndex = flashcards.count - 1
            print("Our current index is \(currentIndex)")
        }
            
        //update buttons
        updateNextPrevButtons()
        
        //update labels
        updateLabels()
        
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons(){
        
        //Disables next button if at the end
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        //Disable prev button if at the beggining
        if currentIndex == 0{
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
    creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue"{
        creationController.initialQuestion = frontLabel.text
        creationController.initialAnswer = backLabel.text
        creationController.initialExtraAnswer1 = btn1.currentTitle
        creationController.initialExtraAnswer2 = btn3.currentTitle
            
            
        }
    }
    
    @IBAction func didTapBtnOne(_ sender: Any) {
        btn1.isHidden = true
    }
    
    @IBAction func didTapBtnTwo(_ sender: Any) {
        self.frontLabel.isHidden = true
    }
    
    @IBAction func didTapBtnThree(_ sender: Any) {
        btn3.isHidden = true
    }
    
    func saveAllFlashcardsToDisk(){
        
        //from flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in return ["question": card.question, "answer": card.answer, "extraAnswer1": card.extraAnswer1, "extraAnswer2":card.extraAnswer2]
        
        }
        //saves array using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //logs it
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String:String]]{
            
            let savedCards = dictionaryArray.map{dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer:dictionary["answer"]!, extraAnswer1: dictionary["extraAnswer1"]!, extraAnswer2: dictionary["extraAnswer2"]!)}
            
            flashcards.append(contentsOf: savedCards)
        }
        
    }
}

